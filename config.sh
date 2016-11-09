#!/bin/bash

DISK='/dev/sda'
#DISK='/dev/vda'
FQDN='archbase'
KEYMAP='us'
LANGUAGE='en_US.UTF-8'
PASSWORD='password1234'  # super insecure, please change
TIMEZONE='UTC'

CONFIG_SCRIPT='/usr/local/bin/arch-config.sh'
ROOT_PARTITION="${DISK}1"
TARGET_DIR='/mnt'

VAGRANT=no
VIRTUALBOX=no
ROOT_TTY_AUTOLOGIN=yes
ROOT_ALLOW_SSH=yes
