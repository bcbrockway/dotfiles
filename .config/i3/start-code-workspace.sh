#!/bin/bash

set -e

i3-msg 'workspace 3; append_layout /home/bbrockway/.config/i3/workspace-3.json'
nohup code &
nohup alacritty &
