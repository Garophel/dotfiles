#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

[ -f ~/.xprofile ] && . ~/.xprofile

#twm &
#xclock -geometry 50x50-1+1 &
#xterm -geometry 80x50+494+51 &
#xterm -geometry 80x20+494-0 &
#exec xterm -geometry 80x66+0+0 -name login

wm=xmonad

if [ "$wm" = 'xmonad' ]; then
    dunst &
    nm-applet &
    feh --bg-scale ~/.wallpaper/bg.png &
    compton -GC &
    trayer \
        --edge top \
        --align right \
        --widthtype request \
        --width 80 \
        --transparent true \
        --padding 6 \
        --alpha 56 \
        --tint 0x220011 \
        --monitor "primary" \
        --SetDockType true \
        --SetPartialStrut true \
        --expand true \
        --height 21 &
fi

setxkbmap -option caps:escape -layout 'fi' -model thinkpad

exec $wm
#exec i3
#exec dwm > ~/.dwm.log
