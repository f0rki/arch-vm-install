#!/bin/bash

DISK='/dev/sda'
#DISK='/dev/vda'
FQDN='archbase'
KEYMAP='us'
LANGUAGE='en_US.UTF-8'
PASSWORD='password1234'  # super insecure, please change
TIMEZONE='UTC'
PACKAGE_LIST='docker zsh grml-zsh-config tmux git'
# name of the user that will be created
CREATE_USER="u"
# add ssh public keys from github user
GITHUB_USER_SSHKEYS=''
# select fastest mirror from this country
MIRROR_COUNTRY=""
# prepare virtual machine for vagrant
VAGRANT=no
# prepare for virtualbox
VIRTUALBOX=no
# enable autologin for root on tty1
ROOT_TTY_AUTOLOGIN=yes
# enable/disable root login via ssh
ROOT_ALLOW_SSH=yes

# usually you won't need to change those
CONFIG_SCRIPT='/usr/local/bin/arch-config.sh'
ROOT_PARTITION="${DISK}1"
TARGET_DIR='/mnt'
