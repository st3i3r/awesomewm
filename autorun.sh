#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

xrdb ~/.Xdefaults
# xcompmgr &
run mpd
run setxkbmap -layout "us,ru" -option "grp:alt_shift_toggle"
run udiskie -a -n &
run xautolock -detectsleep -time 30 -locker "/home/$USER/.config/awesome/lock.sh" &
