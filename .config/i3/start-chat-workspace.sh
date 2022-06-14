#!/bin/sh

i3-msg 'workspace 9; append_layout /home/bbrockway/.config/i3/chat-workspace.json'
nohup google-chrome-stable --app=https://mail.google.com/chat/u/0/#chat/welcome &
nohup google-chrome-stable --app=https://workflowy.com/#/80677c003b45 &
nohup google-chrome-stable --app=https://www.flowdock.com &
