#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}
run compton -CGb --config ~/.config/compton/compton.conf
run mpd
run setxkbmap -layout "us,ru" -option "grp:alt_shift_toggle"
run udiskie -0 -a -n
#run nm-applet
#run xautolock -detectsleep -time 10 -locker "/home/elliot/.config/awesome/i3lock.sh" 
