#!/bin/bash

if [ -z "$1" ]; then
	echo 'Please provide a YT url'
	exit 2
fi

mpv --title 'ytcorner' $1
