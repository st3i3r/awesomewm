#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

xrdb ~/.Xdefaults
run compton -CGb --config ~/.config/compton/compton.conf
run mpd
run setxkbmap -layout "us,ru" -option "grp:alt_shift_toggle"
run udiskie -a -n
run xautolock -detectsleep -time 10 -locker "/home/$USER/.config/awesome/lock.sh" 
