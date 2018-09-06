#!/bin/bash

# Configuration

#jmp_dist=39
jmp_dist=37


# Script begins

case $1 in
	jmp_up)
		xdotool mousemove_relative -- 0 -$jmp_dist
		;;
	jmp_down)
		xdotool mousemove_relative -- 0 $jmp_dist
		;;
	jmp_left)
		xdotool mousemove_relative -- -$jmp_dist 0
		;;
	jmp_right)
		xdotool mousemove_relative -- $jmp_dist 0
		;;
	lclick)
		xdotool click 1
		;;
	mclick)
		xdotool click 2
		;;
	rclick)
		xdotool click 3
		;;
	*)
		echo 'Invalid option'
		exit 1
		;;
esac
