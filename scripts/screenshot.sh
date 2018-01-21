#!/bin/sh

#import -window root screenshot.jpg
SHOT_DIR="$HOME/pics/screenshots/"
if [ ! -d "$SHOT_DIR" ]; then
	echo "ERR: Screenshot dir doesn't exist"
	exit 1
fi

filename=`date '+%Y.%m.%d_%H.%M.%S'`
imgformat='.png'

if [ -e "$SHOT_DIR""$filename""$imgformat" ]; then
#	echo 'file exists'
	filename="$filename."`date '+%N'`
#else
#	echo "file doesn't exist"
fi

filename="$SHOT_DIR""$filename""$imgformat"

if [ -e "$filename" ]; then
	echo 'ERR: screen already exists with filename "'"$filename"'"'
	exit 2
fi

import -window root "$filename"

echo 'Screenshot saved into file: '"$filename"
