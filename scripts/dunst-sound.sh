#!/bin/bash

case "$1" in
    --bell-ding)
        sound="$HOME/.sounds/411749__natty23__bell-ding.wav"
    ;;
    *)
        sound="$HOME/.sounds/411749__natty23__bell-ding.wav"
    ;;
esac

aplay "$sound" >/dev/null 2>/dev/null
