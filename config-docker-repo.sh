#!/bin/bash

# Prompt user for Docker username
read -p "Enter your Docker username: " DOCKER_USERNAME
echo

# Prompt user for Docker password
read -s -p "Enter your Docker password: " DOCKER_PASSWORD
echo

docker login --username "$DOCKER_USERNAME" --password "$DOCKER_PASSWORD
