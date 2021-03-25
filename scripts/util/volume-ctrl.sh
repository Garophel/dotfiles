#!/bin/bash

pasink=0

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
    set-mute)
        pactl set-sink-mute $pasink 1
        ;;
esac

pkill -RTMIN+1 i3blocks
