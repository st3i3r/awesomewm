#!/bin/bash

xwinwrap -ov -g 1920x1080 -- mpv -wid WID ~/.config/awesome/wallpaper.gif --no-osc --no-osd-bar --loop-file --player-operation-mode=cplayer --panscan=1.0 --no-input-default-bindings
