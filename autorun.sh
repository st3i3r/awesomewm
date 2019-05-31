#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

run mpd
run setxkbmap -layout "us,ru" -option "grp:alt_shift_toggle"
run udiskie -0 -a -n
notify-send "Hello Friend"
