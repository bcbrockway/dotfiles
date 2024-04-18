#!/bin/sh

# Load workspace layout
i3-msg 'workspace 9; append_layout /home/bbrockway/.config/i3/chat-workspace.json'

## Google Chat
 nohup google-chrome-stable --app=https://mail.google.com/chat/u/0/#chat/welcome &
# firefoxpwa site launch 01H63JMP3QZ1A7GK483S76ZD7A

## Workflowy
 nohup google-chrome-stable --app=https://workflowy.com/#/39f4f186c2fb &
# firefoxpwa site launch 01H3KQG4K0076P3CVJP5RX28T5

## Authy
#nohup authy &

