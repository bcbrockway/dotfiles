#!/bin/sh

i3-msg 'workspace 2; append_layout /home/bbrockway/.config/i3/workspace-2.json'
nohup chromium &
nohup chromium --app-id=chfbpgnooceecdoohagngmjnndbbaeip &
nohup chromium --app=https://www.flowdock.com &
