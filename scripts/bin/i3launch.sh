#!/bin/bash

prog=$1
shift
i3-msg "exec --no-startup-id $prog $@" 2>&1 1>/dev/null
