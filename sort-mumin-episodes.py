#!/usr/bin/env python3

import argparse
import os
import re
import shutil


G_EPISODES = {
  "Vår i Mumindalen": (1, 1),
  "Den förtrollade hatten": (1, 2),
  "Båten på stranden": (1, 3),
  "Hattifnattarnas ö": (1, 4),
  "Strandfynd": (1, 5),
  "Små gäster": (1, 6),
  "Kappsäcken": (1, 7),
  "Den stora festen": (1, 8),
  "Det osynliga barnet, del 1": (1, 9),
  "Det osynliga barnet, del 2": (1, 10),
  "Snorken flyger": (1, 11),
  "Mumin och piraten": (1, 12),
  "Den sista draken i världen": (1, 13),
  "Fru Filifjonk flyttar till Mumindalen": (1, 14),
  "Prinsessan av Mumindalen": (1, 15),
  "Möte med marsmänskor": (1, 16),
  "Muminpappan längar efter äventyr": (1, 17),
  "Förtrollade frön": (1, 18),
  "Muminfamiljen bor i en djungel": (1, 19),
  "Muminfamiljen räddar vilddjur": (1, 20),
  "Snusmumriken längar söderut": (1, 21),
  "Mumintrollet upplever vintern": (1, 22),
  "Vintergäster": (1, 23),
  "Var dröjer Snusmumriken?": (1, 23),

  "Fyren": (1, 25),
  "Fyrvaktaren": (1, 26),
  "Rika faster kommer på besök": (1, 27),
  "Ett flytande spökhus": (1, 28),
  "De borttappade barnen": (1, 29),
  "En annorlunda midsommar": (1, 30),
  "Snorkens flygande skepp": (1, 31),
  "Guldfisken": (1, 32),
  "Anden i lampan": (1, 33),
  "Drakflygning": (1, 34),
  "Häxan": (1, 35),
  "Julen kommer": (1, 36),
  "Det stora vinterbålet": (1, 37),
  "Förtrollningen": (1, 38),
  "Dunder och brak på natten": (1, 39),
  "Hemligheten med fyrverkeriet": (1, 40),
  "Skurkar i Mumindalen": (1, 41),
  "Solförmörkelsen": (1, 42),
  "Primadonnan": (1, 43),
  "Födelsedagspresenten": (1, 44),
  "Att bygga ett hus": (1, 45),
  "Vita grevinnan": (1, 46),
  "Den varma källan": (1, 47),
  "Lek med bubblor": (1, 48),
  "Jättepumpan": (1, 49),
  "Rösten inifrån trädet": (1, 50),
  "Snorkfröken blir synsk": (1, 51),
  "Skattjakten": (1, 52),

  "Vattenfen": (1, 53),
  "Mymlans diamant": (1, 54),
  "Muminpappans andra ungdom": (1, 55),
  "Förtrollade körsbär": (1, 56),
  "Moderlig kärlek": (1, 57),
  "Konstnärer i Mumindalen": (1, 58),
  "Muminpappans olyckliga barndom": (1, 59),
  "Hemska Lilla My": (1, 60),
  "Mumin, spåman": (1, 61),
  "Häxkonster": (1, 62),
  "Muminpappans stormiga ungdom": (1, 63),
  "Fågelfamilj i fara": (1, 64),
  "Muminpappan grundar en koloni": (1, 68),
  "Vampyren": (1, 66),
  "Stolen": (1, 67),
  "Den fina klänningsbalen": (1, 65),
  "Fågeln Feniks": (1, 69),
  "Den stora fisken": (1, 70),
  "De lata svamparna": (1, 71),
  "Mumin och delfinen": (1, 72),
  "Mumin och grottan": (1, 73),
  "En underbar present": (1, 74),
  "Drottningsmaragden": (1, 75),
  "Att måla ett hus": (1, 76),
  "Den stora flygtävlingen": (1, 77),
  "Resa söderut": (1, 78),
}

G_SEASONS = [1, 2, 3]

def match_season_episode(episode_name):
  match_name = episode_name.replace("_", " ").strip()
  if match_name in G_EPISODES:
    episode_details = G_EPISODES[match_name]
    return (episode_details[0], episode_details[1])
  raise Exception("Unknown episode: \"{}\"".format(episode_name))

def move_moomin_files(in_dir, out_dir):
  episodes = os.listdir(in_dir)
  regex = re.compile("(I_Mumindalen_avsnitt_)([0-9]*)_-_(.*)_\[.*\](.mp4)")

  for season in G_SEASONS:
    season_path = os.path.join(out_dir, "Season_{}".format(season))
    if not os.path.exists(season_path):
      os.mkdir(season_path)

  i = 0
  for ep in episodes:
    match = regex.search(ep)
    episode_number = int(match.group(2))
    episode_name = match.group(3)
    file_extension = match.group(4)
    season, season_episode = match_season_episode(episode_name)
    out_filename = "S{}E{}_{}".format(season, season_episode, episode_name + file_extension)
    input_file = os.path.join(in_dir, ep)
    output_file = os.path.join(out_dir, "Season_{}".format(season), out_filename)
    print("{}: {}".format(i, out_filename))
    shutil.copyfile(input_file, output_file)
    i += 1


if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument("in_dir")
  parser.add_argument("out_dir")
  args = parser.parse_args()
  move_moomin_files(args.in_dir, args.out_dir)
