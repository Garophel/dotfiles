#!/bin/bash

usage() {
    echo "$0 <command>"
    echo '        playpause  - alias for toggle'
    echo '        toggle'
    echo '        stop'
    echo '        next'
    echo '        prev'
    echo '        vol-up'
    echo '        vol-down'
}

if [ -z "$1" ]; then
    echo 'Provide a command!'
    usage
    exit 1
fi

pasink=0

case "$1" in
    playpause|toggle)
        mpc toggle
        ;;
    stop)
        mpc stop
        ;;
    next)
        mpc next
        ;;
    prev)
        mpc prev
        ;;
    vol-up)
        mpc volume +5
        ;;
    vol-down)
        mpc volume -5
        ;;
esac

pkill -RTMIN+2 i3blocks
