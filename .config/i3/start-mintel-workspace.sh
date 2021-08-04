#!/bin/sh

i3-msg 'workspace 2; append_layout /home/bbrockway/.config/i3/workspace-2.json'
nohup google-chrome-stable &
nohup google-chrome-stable --app=https://mail.google.com/chat/u/0/#chat/welcome &
nohup google-chrome-stable --app=https://www.flowdock.com &
