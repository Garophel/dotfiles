#!/bin/bash

equat=`</dev/null dmenu -p 'plot>'`

if [ $? -ne 0 ]; then
	notify-send 'No equation given'
	exit 1
fi

if [ -z "$equat" ]; then
	notify-send 'No equation given'
	exit 1
fi

gnuplot -p -e "plot $equat" || notify-send 'Invalid equation'
