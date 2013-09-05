#!/bin/bash
# This should work whether you are already in a TMUX session or not...
# Irssi directory is assumed to be in the user's home dir

IRSSI_PATH=/home/fille

sleep 30

if [ -z "$TMUX" ]
then
	tmux new-session -d -s fille "irssi"
fi

