#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Update package lists
apt update

# Install basic operational tools
apt install -y vim lsof curl wget git
