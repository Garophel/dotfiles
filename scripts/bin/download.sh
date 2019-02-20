#!/bin/bash

[ -z "$1" ] && exit 1

cd ~/videos/youtube || exit 2

youtube-dl "$1"
