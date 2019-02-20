#!/bin/bash

usage() {
    echo "$0 <command>"
    echo '        up'
    echo '        down'
    echo '        mute'
}

if [ -z "$1" ]; then
    echo 'Provide a command!'
    usage
    exit 1
fi

pasink=0

case "$1" in
    up)
        pactl set-sink-mute $pasink false
        pactl set-sink-volume $pasink +5%
        ;;
    down)
        pactl set-sink-mute $pasink false
        pactl set-sink-volume $pasink -5%
        ;;
    mute)
        pactl set-sink-mute $pasink toggle
        ;;
esac

pkill -RTMIN+1 i3blocks
