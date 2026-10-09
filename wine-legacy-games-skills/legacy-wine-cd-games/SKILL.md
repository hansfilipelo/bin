---
name: legacy-wine-cd-games
description: Install and launch Windows 95/98-era games from CD-ROM in a dedicated Wine prefix, then create a GNOME launcher with optional Gamescope aspect-preserving upscaling. Use when a user wants to install an old Windows game or educational application from physical media using Wine.
---

# Legacy Wine CD games

Use this workflow for old Windows CD-ROM games and educational applications. Preserve the host configuration: use a dedicated per-user Wine prefix and user-local desktop entries only.

## 1. Inspect before changing anything

1. Check `wine --version`, installed Wine variants, the current display session, and free disk space.
2. Identify the CD-ROM mount point using `findmnt -S /dev/sr0` or mounted `iso9660`/`udf` filesystems.
3. List the disc's top-level files and locate likely installers such as `setup.exe`, `install.exe`, or localized names. Quote every path; old media commonly contains spaces and non-ASCII characters.
4. Do not use `WINEARCH=win32` with Wine WoW64 versions that support legacy 16-bit and 32-bit applications. Let Wine select its normal WoW64 prefix layout.

## 2. Create and validate a dedicated prefix

1. Ask for or choose a descriptive prefix name under `~/.wine-prefixes`, for example `~/.wine-prefixes/<game-id>`.
2. Initialize it with:

   ```bash
   WINEPREFIX="$HOME/.wine-prefixes/<game-id>" wineboot -u
   ```

3. If it does not finish promptly, inspect the process state, Wine server, registry timestamps, and desktop-session environment. Do not assume initialization completed merely because prefix files exist.
4. If one installed Wine build hangs during initialization, stop only the affected prefix server:

   ```bash
   WINEPREFIX="$HOME/.wine-prefixes/<game-id>" wineserver -k
   ```

   Then initialize a separate prefix with another installed Wine build, such as a stable build. Never run a different Wine build against an existing prefix.
5. Configure every new legacy-game prefix for Windows 98 compatibility:

   ```bash
   WINEPREFIX="$HOME/.wine-prefixes/<game-id>" wine reg add 'HKCU\Software\Wine' /v Version /t REG_SZ /d win98 /f
   ```

6. Verify the `Version` registry value is `win98`. Prefer the executable belonging to the Wine build that successfully initialized the prefix for every subsequent command.

## 3. Create the installer script

1. Write an executable installer script at:

   ```text
   ~/Skrivbord/install-<game-id>.sh
   ```

2. Make the script verify that the mounted installer exists, then use the dedicated prefix, selected Wine executable, and quoted mounted-disc path:

   ```bash
   #!/usr/bin/env bash
   set -euo pipefail

   installer="/path/to/installer.exe"

   if [[ ! -f "$installer" ]]; then
     printf 'Installer not found: %s\n' "$installer" >&2
     exit 1
   fi

   exec env WINEPREFIX="$HOME/.wine-prefixes/<game-id>" <wine-binary> "$installer"
   ```

3. Set mode `755`, verify the script is executable, and provide its exact path. Do not automatically execute the installer unless the user asks to do so.

## 4. Create a GNOME launcher after installation

1. Locate the installed `.exe` inside `drive_c`. Use a Unix path in the `Exec` key; Wine accepts it and it avoids invalid desktop-entry escaping.
2. Write a user-local desktop entry at:

   ```text
   ~/.local/share/applications/<game-id>.desktop
   ```

3. Use this baseline structure:

   ```ini
   [Desktop Entry]
   Type=Application
   Name=<display name>
   Comment=<short description>
   Exec=env WINEPREFIX=/home/<user>/.wine-prefixes/<game-id> <wine-binary> "/home/<user>/.wine-prefixes/<game-id>/drive_c/.../Game.exe"
   Terminal=false
   Categories=Game;
   StartupNotify=true
   ```

4. Do not put an unescaped Windows path such as `C:\Program Files\...` in `Exec`. GNOME/GIO may reject the complete launcher even if basic desktop-file validation succeeds.
5. Run `desktop-file-validate` and `update-desktop-database ~/.local/share/applications`.
6. Verify GNOME recognizes the launcher with `Gio.DesktopAppInfo.new('<game-id>.desktop')`. If it returns `None`, fix the entry rather than assuming a cache refresh will solve it.

## 5. Add the game's icon

1. Look for an installed `.ico` file or a matching disc icon. Do not reference the mounted CD directly, because it disappears when the disc is ejected.
2. Convert or extract a suitable icon as PNG and save it in a user icon theme directory, for example:

   ```text
   ~/.local/share/icons/hicolor/48x48/apps/<game-id>.png
   ```

3. Add `Icon=<game-id>` to the desktop entry, then refresh the desktop-entry database. A local `hicolor` overlay may not have its own `index.theme`; an icon-cache generation failure for that partial directory is non-fatal.

## 6. Optional Gamescope scaling

Only add Gamescope when the user asks to upscale the game. First check that `gamescope` is installed and verify Vulkan support from the active GPU; do not assume Vulkan is unavailable because the GPU is old.

For a 4:3 game rendered at `<game-width>x<game-height>` on a display of `<display-width>x<display-height>`, preserve aspect ratio and fill the display height with:

```ini
Exec=gamescope --fullscreen --nested-width <game-width> --nested-height <game-height> --output-width <display-width> --output-height <display-height> --scaler fit --filter linear -- env WINEPREFIX=/home/<user>/.wine-prefixes/<game-id> <wine-binary> "/home/<user>/.wine-prefixes/<game-id>/drive_c/.../Game.exe"
```

`--scaler fit` preserves the game's aspect ratio. On a 1920x1080 display, a 640x480 game becomes 1440x1080 with left and right pillarboxes; it must not be stretched to 16:9.

## 7. Final checks

1. Confirm the desktop entry resolves through GIO and reports the desired name, executable, and icon.
2. State the exact prefix path, launcher ID, Wine build, and scaling behavior.
3. Mention non-fatal Wayland clipboard/icon-protocol warnings only if they affect functionality. Do not present them as the cause of an unrelated Wine failure.
