#!/bin/bash

# Function to check if a command is installed
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

echo "##############################################################################"
echo "Installing Trivy..."
echo "##############################################################################"
# Install Trivy
if ! command_exists trivy; then
    echo "Trivy is not installed. Downloading and installing..."
    wget https://github.com/aquasecurity/trivy/releases/download/v0.18.3/trivy_0.18.3_Linux-64bit.deb
    sudo dpkg -i trivy_0.18.3_Linux-64bit.deb
    if ! command_exists trivy; then
        echo "Failed to install Trivy."
        exit 1
    fi
fi

echo "##############################################################################"
echo "Installing Docker..."
echo "##############################################################################"
# Install Docker
if ! command_exists docker; then
    echo "Docker is not installed. Installing Docker..."
    sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    if ! command_exists docker; then
        echo "Failed to install Docker."
        exit 1
    fi
fi

echo "##############################################################################"
echo "Installing Terraform..."
echo "##############################################################################"
# Install Terraform via Snap
if ! command_exists terraform; then
    echo "Terraform is not installed. Installing Terraform..."
    sudo snap install terraform --classic
    if ! command_exists terraform; then
        echo "Failed to install Terraform."
        exit 1
    fi
fi

echo "##############################################################################"
echo "Installing kubectl..."
echo "##############################################################################"
# Install kubectl
if ! command_exists kubectl; then
    echo "kubectl is not installed. Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    if ! command_exists kubectl; then
        echo "Failed to install kubectl."
        exit 1
    fi
fi

echo "##############################################################################"
echo "Installing AWS CLI..."
echo "##############################################################################"
# Install AWS CLI
if ! command_exists aws; then
    echo "AWS CLI is not installed. Installing AWS CLI..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo apt-get install unzip -y > /dev/null 2>&1  # Suppress output
    unzip awscliv2.zip > /dev/null 2>&1  # Suppress output
    sudo ./aws/install > /dev/null 2>&1  # Suppress output
    if ! command_exists aws; then
        echo "Failed to install AWS CLI."
        exit 1
    fi
fi

echo "##############################################################################"
echo "Installing Temurin JDK..."
echo "##############################################################################"
# Install Temurin JDK
if ! command_exists java; then
    echo "Temurin JDK is not installed. Installing Temurin JDK..."
    sudo apt update -y
    sudo touch /etc/apt/keyrings/adoptium.asc
    sudo wget -O /etc/apt/keyrings/adoptium.asc https://packages.adoptium.net/artifactory/api/gpg/key/public
    echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list > /dev/null
    sudo apt update -y
    sudo apt install temurin-17-jdk -y
fi

echo "##############################################################################"
echo "Installing Jenkins..."
echo "##############################################################################"
# Install Jenkins
if ! command_exists jenkins; then
    echo "Jenkins is not installed. Installing Jenkins..."
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
        https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
        https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
        /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update  # Errors might occur that don't influence installation and work of Jenkins
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y fontconfig openjdk-17-jre jenkins > /dev/null 2>&1  # Suppress output
fi

# Display initialAdminPassword
echo "##############################################################################"
echo "All tools (Trivy, Docker, Terraform, kubectl, AWS CLI, Temurin JDK, Jenkins) are installed."
echo "##############################################################################"
echo "Checking Jenkins status..."
sudo systemctl status jenkins | head -n 10

echo "InitialAdminPassword:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Display Java version
echo "##############################################################################"
echo "Java version:"
java --version

exit 0
