#!/bin/bash

# Check if dropdown doesn't exist
if ! tmux has-session -t dropdown 2> /dev/null; then
    # Doesn't exist, lauch it
    i3-msg 'exec --no-startup-id st -n dropdown -e tmux new-session -A -s dropdown'
fi

