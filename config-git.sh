#!/bin/bash

read -p "Enter your Git email: " GITEMAIL
echo
read -p "Enter your Git name: " GITNAME
echo

git config --global user.email "$GITEMAIL"
git config --global user.name "$GITNAME"
