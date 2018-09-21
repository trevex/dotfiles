#!/usr/bin/env bash
title=`exec playerctl metadata xesam:title`
artist=`exec playerctl metadata xesam:artist`
echo "$title - $artist"

