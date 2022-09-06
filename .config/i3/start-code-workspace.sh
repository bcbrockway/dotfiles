#!/bin/bash

set -e

i3-msg 'workspace 3; append_layout /home/bbrockway/.config/i3/code-workspace.json'
nohup code &
nohup alacritty &

