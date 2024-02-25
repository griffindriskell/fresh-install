#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Function to install base ops tools
install_base_ops_tools() {
    echo "Running install-ops-tools.sh..."
    # Update package lists
    apt update
    # Install basic operational tools
    apt install -y vim lsof curl wget git
}

# Function to install Docker
install_docker() {
    echo "Running install-docker.sh..."
    # Install Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    # Clean up
    rm get-docker.sh
}

# Function to install Kubernetes
install_kubernetes() {
    echo "Running install-kubernetes.sh..."
    # Install K3s
    curl -sfL https://get.k3s.io | sh -
    # Download Google Cloud public signing key
    curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    # Add Kubernetes apt repo to download kubectl
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
    # Install kubectl
    apt update && apt install -y kubectl
    # Download Helm GPG Key
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    # Add Helm GPG Key
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
    # Install Helm
    apt update && apt install -y helm
}

# Function to configure Bash Aliases
configure_bash_aliases() {
    echo "Running config-bash_aliases.sh..."
    cat ./bash_aliases > ~/.bash_aliases && source ~/.bash_aliases
}

# Function to configure git profile
configure_git_profile() {
    echo "Running config-git.sh..."
    read -p "Enter your Git email: " GITEMAIL
    echo
    read -p "Enter your Git name: " GITNAME
    echo
    git config --global user.email "$GITEMAIL"
    git config --global user.name "$GITNAME"
}

# Function to configure Docker Hub repo
configure_docker_repo() {
    echo "Running config-docker-repo.sh..."
    # Prompt user for Docker username
    read -p "Enter your Docker username: " DOCKER_USERNAME
    echo
    # Prompt user for Docker password
    read -s -p "Enter your Docker password: " DOCKER_PASSWORD
    echo
    docker login --username "$DOCKER_USERNAME" --password "$DOCKER_PASSWORD
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
