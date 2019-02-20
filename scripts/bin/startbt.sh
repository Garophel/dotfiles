#!/bin/sh

sudo rfkill unblock bluetooth
sudo systemctl start bluetooth

echo -e 'power on\n' | bluetoothctl
