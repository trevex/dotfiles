#!/usr/bin/env bash
if [[ $(playerctl status) == 'Playing' ]];
  then
    echo "pause"
  else
    echo "play"
fi

