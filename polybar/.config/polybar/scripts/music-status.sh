#!/usr/bin/env bash
if [[ $(playerctl status 2>&1) = "No players found" ]]; then
    exit 3
fi
