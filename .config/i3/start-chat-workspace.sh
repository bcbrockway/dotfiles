#!/bin/sh

i3-msg 'workspace 9; append_layout /home/bbrockway/.config/i3/chat-workspace.json'
nohup google-chrome-stable --app=https://mail.google.com/chat/u/0/#chat/welcome &
nohup google-chrome-stable --app=https://workflowy.com/#/5069a6b6faff?q=-is%3Acomplete%20OR%20last-changed%3A1d &
#nohup google-chrome-stable --app=https://www.evernote.com/client/web?login=true &
nohup authy &

