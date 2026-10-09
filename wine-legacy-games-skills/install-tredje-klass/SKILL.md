---
name: install-tredje-klass
description: Install and run the Swedish CD-ROM educational game Flygande Start tredje klass on GNOME using a native 32-bit Wine prefix, the disc's 16-bit game runtime, a persistent GNOME launcher/icon, and Xephyr plus Gamescope for correct scaled paletted graphics. Use only for this specific game.
---

# Install Flygande Start tredje klass

Use this skill only for the Swedish *Flygande Start tredje klass* CD, mounted as an `iso9660` filesystem. The game has a 16-bit WinG renderer. It will not work reliably in a Wine WoW64 prefix or when Gamescope receives the game's paletted surface directly.

## Required components

1. Ensure the CD is mounted. Discover the mount with `findmnt -S /dev/sr0`; below, use that path as `$disc`.
2. A native 32-bit Ubuntu Wine loader is required, alongside any WineHQ 64-bit installation:

   ```bash
   sudo dpkg --add-architecture i386
   sudo apt update
   sudo apt install --no-install-recommends wine32:i386
   ```

   Use these binaries, never the default `wine` command:

   ```bash
   wine32=/usr/lib/i386-linux-gnu/wine/wine
   wineserver32=/usr/lib/i386-linux-gnu/wine/wineserver
   ```

3. Install `gamescope` and `xserver-xephyr`. Xephyr is required to translate the game's paletted WinG output before Gamescope scales it.

## Native 32-bit prefix

Use this prefix exactly:

```bash
prefix="$HOME/.wine-prefixes/flygande-start-tredje-klass-32"
```

Create it as an actual 32-bit prefix:

```bash
WINEARCH=win32 WINEPREFIX="$prefix" "$wine32" wineboot -u
WINEPREFIX="$prefix" "$wine32" reg add 'HKCU\Software\Wine' /v Version /t REG_SZ /d win98 /f
grep '^#arch=win32' "$prefix/system.reg"
WINEPREFIX="$prefix" "$wine32" reg query 'HKCU\Software\Wine' /v Version
```

Verify the CD is mapped as `D:` before running setup. Write an installer script at `~/Skrivbord/install-flygande-start-tredje-klass-32.sh` that uses both `$wine32` and `$wineserver32`:

```bash
#!/usr/bin/env bash
set -euo pipefail

installer="/run/media/$USER/3E_KLASS/setup.exe"
wine="/usr/lib/i386-linux-gnu/wine/wine"
wineserver="/usr/lib/i386-linux-gnu/wine/wineserver"

[[ -f "$installer" ]] || { printf 'Installer not found: %s\n' "$installer" >&2; exit 1; }
exec env WINEPREFIX="$HOME/.wine-prefixes/flygande-start-tredje-klass-32" \
  WINESERVER="$wineserver" "$wine" "$installer"
```

Make it executable. Only run it when the user asks.

## Replace the incompatible setup payload

The installer selects `support/w32/3g.exe`, which is incompatible. Replace its runtime with the CD's 16-bit version after setup:

```bash
game="$prefix/drive_c/LB/3G"
backup="$game/incompatible-32bit-backup"
mkdir -p "$backup"

for file in 3g.exe kdi32.dll smackw32.dll wsound32.dll wsb32.txt; do
  [[ -e "$game/$file" ]] && mv "$game/$file" "$backup/$file"
done

install -m 0644 "$disc/support/w16/3g.exe" "$game/3g.exe"
for file in dib.drv smackw16.dll smacke16.dll wsound16.dll; do
  install -m 0644 "$disc/support/w16/$file" "$game/$file"
done
```

If a known-good local `3e_klass` installation exists, copy its whole `drive_c/LB/3G` directory into the new prefix after first backing up the incompatible files. This supplies the proven full 16-bit content payload; update only the CD paths below.

Install the WinG support files to the prefix's Windows system directory:

```bash
mkdir -p "$prefix/drive_c/windows/system"
for file in wing.dll wing32.dll wingde.dll wingdib.drv wingpal.wnd; do
  install -m 0644 "$disc/support/winsys/$file" "$prefix/drive_c/windows/system/$file"
done
```

## CD mapping

The 16-bit game requires `E:\3G\` with the trailing backslash and checks the drive type. Map the mounted disc to `E:` in this prefix only:

```bash
ln -sfn "$disc" "$prefix/dosdevices/e:"
ln -sfn /dev/sr0 "$prefix/dosdevices/e::"
WINEPREFIX="$prefix" "$wine32" reg add 'HKLM\Software\Wine\Drives' /v e: /t REG_SZ /d cdrom /f
```

Set exact paths in `"$game/3G.INI"`:

```ini
SoundCDPath=E:\3G\
CDPath=E:\3G\
```

Verify Wine reads `E:\3G\3g.ini`:

```bash
WINEPREFIX="$prefix" "$wine32" cmd /c 'dir E:\3G\3g.ini'
```

## Scaling launcher

The game must render to a **24-bit** Xephyr display. `x8` causes a palette-corruption black/red/green image. Gamescope must scale Xephyr's output, not the game's direct paletted surface.

Create `~/.local/bin/run-flygande-start-tredje-klass-xephyr`:

```bash
#!/usr/bin/env bash
set -euo pipefail

game_dir="$HOME/.wine-prefixes/flygande-start-tredje-klass-32/drive_c/LB/3G"
wine="/usr/lib/i386-linux-gnu/wine/wine"
display=":99"

Xephyr "$display" -screen 640x480x24 -ac -nolisten tcp &
xephyr_pid=$!
cleanup() {
  kill "$xephyr_pid" 2>/dev/null || true
  wait "$xephyr_pid" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

for _ in $(seq 1 40); do
  if DISPLAY="$display" xdpyinfo >/dev/null 2>&1; then
    cd "$game_dir"
    DISPLAY="$display" "$wine" 3g.exe
    exit $?
  fi
  sleep 0.1
done

printf 'Xephyr did not start a 24-bit display.\n' >&2
exit 1
```

Create `~/.local/bin/launch-flygande-start-tredje-klass-32`:

```bash
#!/usr/bin/env bash
set -euo pipefail

wineserver="/usr/lib/i386-linux-gnu/wine/wineserver"
runner="$HOME/.local/bin/run-flygande-start-tredje-klass-xephyr"
log_dir="$HOME/.local/state/flygande-start-tredje-klass"
log="$log_dir/last-launch.log"

mkdir -p "$log_dir"
printf '%s\n' "--- $(date --iso-8601=seconds) ---" >"$log"
exec gamescope --fullscreen --nested-width 640 --nested-height 480 \
  --output-width 1920 --output-height 1080 --scaler fit --filter linear -- \
  env WINEPREFIX="$HOME/.wine-prefixes/flygande-start-tredje-klass-32" \
  WINESERVER="$wineserver" "$runner" >>"$log" 2>&1
```

Make both scripts executable. On a 1920×1080 display, this provides a 1440×1080 4:3 image with pillarboxes.

## GNOME entry and icon

Copy the CD icon into local user storage:

```bash
icon="$HOME/.local/share/icons/hicolor/32x32/apps/flygande-start-tredje-klass.ico"
mkdir -p "$(dirname "$icon")"
install -m 0644 "$disc/support/3g.ico" "$icon"
```

Create `~/.local/share/applications/flygande-start-tredje-klass.desktop`:

```ini
[Desktop Entry]
Type=Application
Name=Flygande Start tredje klass
Comment=Educational game for third grade
Exec=/home/siri/.local/bin/launch-flygande-start-tredje-klass-32
Icon=/home/siri/.local/share/icons/hicolor/32x32/apps/flygande-start-tredje-klass.ico
Terminal=false
Categories=Game;
StartupNotify=true
```

Use the actual user home path in `Exec` and `Icon`, not `/home/siri` when configuring another account. Validate with:

```bash
desktop-file-validate "$HOME/.local/share/applications/flygande-start-tredje-klass.desktop"
update-desktop-database "$HOME/.local/share/applications"
```

After first installation, remove Wine-generated duplicate game, help, and registration desktop entries. Retain only this launcher. If GNOME still executes a stale previously pinned launcher, log out/in or update the pinned favorite to this launcher.
