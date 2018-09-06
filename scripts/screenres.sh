#!/bin/bash

reslist='1280x800\n960x600'
newres=`echo -e "$reslist" | dmenu -i -p 'screen res> '`

if ! echo -e "$reslist" | grep -w "$newres" > /dev/null; then
	exit 1
fi

xrandr -s "$newres"
killall polybar

i3-msg "exec --no-startup-id $HOME/.config/polybar/launch.sh"
feh --bg-scale ~/.wallpaper/bg.png
