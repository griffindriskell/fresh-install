#!/bin/bash

# Function to install base ops tools
install_base_ops_tools() {
    echo "Running install-ops-tools.sh..."
    ./install-ops-tools.sh
}

# Function to install Docker
install_docker() {
    echo "Running install-docker.sh..."
    ./install-docker.sh
}

# Function to install Kubernetes
install_kubernetes() {
    echo "Running install-kubernetes.sh..."
    ./install-kubernetes.sh
}

# Function to configure Bash Aliases
configure_bash_aliases() {
    echo "Running config-bash_aliases.sh..."
    ./config-bash_aliases.sh
}

# Function to configure git profile
configure_git_profile() {
    echo "Running config-git.sh..."
    ./config-git.sh
}

# Function to configure Docker Hub repo
configure_docker_repo() {
    echo "Running config-docker-repo.sh..."
    ./config-docker-repo.sh
}

# Check if dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it using your package manager."
    exit 1
fi

# Display a dialog box with checkboxes for options
selection=$(dialog --clear --backtitle "Setup Options" --title "Select Setup Options" --checklist "Choose one or more options:" 15 60 6 \
    1 "Install base ops tools" off \
    2 "Install Docker" off \
    3 "Install Kubernetes" off \
    4 "Configure Bash Aliases" off \
    5 "Configure git profile" off \
    6 "Configure Docker Hub repo" off \
    3>&1 1>&2 2>&3)

# Check the exit status
case $? in
    0)
        echo "You chose the following options:"
        for choice in $selection; do
            case $choice in
                1) install_base_ops_tools ;;
                2) install_docker ;;
                3) install_kubernetes ;;
                4) configure_bash_aliases ;;
                5) configure_git_profile ;;
                6) configure_docker_repo ;;
            esac
        done
        ;;
    1)
        echo "Cancelled.";;
    *)
        echo "An unexpected error occurred.";;
esac
