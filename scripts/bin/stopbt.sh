#!/bin/bash

sudo systemctl stop bluetooth
sudo rfkill block bluetooth
