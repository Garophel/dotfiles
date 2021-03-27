#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Start X when logging into TTY1
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then exec startx; fi

if [ -f ~/.bash_prompt ]; then
	source ~/.bash_prompt
else
	export PS1='\u@\H \w\$ '
fi

# Rust
[ -f ~/.cargo/env ] && source ~/.cargo/env

# Scripts
PATH=$PATH:~/scripts/bin

export RANGER_LOAD_DEFAULT_RC='FALSE'
export VISUAL='vim'

alias o='xdg-open'
alias v='vim'
alias ls='ls --color=auto'
alias l='ls'
alias ll='ls -al'
alias l1='ls -1'
alias pss='pass show -c'
alias lock='i3lock -c 333355'
alias sshagent='eval `ssh-agent`'
alias btoff='sudo rfkill block bluetooth'
alias htmlpreview='w3m -T text/html'
alias hostdir='python2 -m SimpleHTTPServer 9090'

alias dotf='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

function img {
	feh -g 640x480 -d "$1"
}

function mvhere {
	mv $@ `pwd`
}

# yes, I'm that lazy
function c {
	cd $@
	ls
}

# bash functions for quickly connecting to specific remote servers
[ -f ~/.bash_ssh_alias ] && source ~/.bash_ssh_alias

function mpdon {
	if systemctl --user status mpd > /dev/null 2>&1; then
		echo 'MPD already running'
	else
		systemctl --user start mpd
	fi
}

function mpdoff {
	if systemctl --user status mpd > /dev/null 2>&1; then
		systemctl --user stop mpd
	else
		echo 'MPD not running'
	fi
}

# enable vi-input mode
set -o vi
source "$HOME/.cargo/env"
