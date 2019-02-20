#!/bin/bash

[ -z "$1" ] && exit 1
emacsclient -n $1 || st -e vim $1
