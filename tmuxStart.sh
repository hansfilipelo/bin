#!/bin/bash
SESSION=$USER

# Start session
tmux new-session -d -s $SESSION

# Start weechat
tmux new-window 'weechat'

