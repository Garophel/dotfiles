#!/bin/bash

if [ -z "$1" ]; then
    echo 'Please provide a URL'
    exit 1
fi

# Options:
prog=$(dmenu -p 'URL opener' <<EOF
qutebrowser
waterfox
mpv
mpv (ytcorner)
mpv (audio-only)
ytdl
EOF
)

i3launch=~/scripts/bin/i3launch.sh

case "$prog" in
    qutebrowser)
        $i3launch qutebrowser "$1"
        ;;
    waterfox)
        $i3launch waterfox "$1"
        ;;
    mpv)
        $i3launch mpv "$1"
        ;;
    'mpv (ytcorner)')
        $i3launch mpv "--title ytcorner --ytdl-format=worst $1"
        ;;
	'mpv (audio-only)')
		$i3launch mpv --vid=no "$1"
		;;
	ytdl)
		$i3launch bash ~/scripts/bin/download.sh "$1"
		;;
    *)
        notify-send 'Failed to open url'
        ;;
esac
