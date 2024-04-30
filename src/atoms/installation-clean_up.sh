#!/bin/bash

# Function to check if a command is installed
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Remove Trivy
if command_exists trivy; then
    echo "Removing Trivy..."
    sudo apt-get remove --purge trivy -y
fi

# Remove Docker
if command_exists docker; then
    echo "Removing Docker..."
    sudo apt-get remove --purge docker-ce docker-ce-cli containerd.io -y
fi

# Remove Terraform
if command_exists terraform; then
    echo "Removing Terraform..."
    sudo snap remove terraform
fi

# Remove kubectl
if command_exists kubectl; then
    echo "Removing kubectl..."
    sudo rm -rf /usr/local/bin/kubectl
fi

# Remove AWS CLI
if command_exists aws; then
    echo "Removing AWS CLI..."
    sudo rm -rf /usr/local/bin/aws
    sudo rm -rf /usr/local/aws-cli
fi

# Remove Temurin JDK
if command_exists java; then
    echo "Removing Temurin JDK..."
    sudo apt-get remove --purge temurin-17-jdk -y
fi

# Remove Jenkins
if command_exists jenkins; then
    echo "Removing Jenkins..."
    sudo apt-get purge --auto-remove jenkins -y
fi

# Clean up additional files and directories
sudo rm -f /usr/share/keyrings/jenkins-keyring.asc
sudo rm -f /etc/apt/sources.list.d/jenkins.list
sudo rm -f /etc/apt/keyrings/adoptium.asc
sudo rm -f /etc/apt/sources.list.d/adoptium.list
sudo rm -f /var/lib/jenkins/secrets/initialAdminPassword
sudo rm -f ~/awscliv2.zip
sudo rm -f ~/aws
sudo rm -rf /home/ubuntu/aws
sudo rm -f ~/kubectl
sudo rm -f ~/trivy_0.18.3_Linux-64bit.deb

echo "Cleanup completed."
exit 0

