#!/usr/bin/env bash
kill -SIGUSR1 $(ps -eo pid,comm | grep sxhkd | awk '{ print $1 }')
