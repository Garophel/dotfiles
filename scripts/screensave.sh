#!/bin/bash

# xset q | grep 'DPMS is Enabled'
# enabled=$?

enable=$(echo -e 'enable\ndisable' | dmenu -p 'screensaver:')

if [ "$enable" = 'enable' ]; then
    xset +dpms
    xset s blank
    xset s on

    echo 'Screensaver enabled'
    exit 0
fi

if [ "$enable" = 'disable' ]; then
    xset -dpms
    xset s noblank
    xset s off

    echo 'Screensaver disabled'
    exit 0
fi

echo 'Invalid input, screensaver state not changed'
