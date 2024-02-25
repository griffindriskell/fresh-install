#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

cat bash_aliases > ~/.bash_aliases && source ~/.bash_aliases
