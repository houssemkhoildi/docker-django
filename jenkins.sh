#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install OpenJDK 11 (Java Development Kit)
echo "Installing OpenJDK 11..."
sudo apt install openjdk-11-jdk -y

# Verify Java installation
if java -version >/dev/null 2>&1; then
    echo "Java installed successfully."
else
    echo "Java installation failed. Exiting..."
    exit 1
fi

# Add Jenkins repository and import key
echo "Adding Jenkins repository..."
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Update package list after adding Jenkins repository
echo "Updating package list..."
sudo apt update

# Install Jenkins
echo "Installing Jenkins..."
sudo apt install jenkins -y

# Start and enable Jenkins service
echo "Starting and enabling Jenkins service..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Check Jenkins service status
if sudo systemctl is-active --quiet jenkins; then
    echo "Jenkins service started successfully."
else
    echo "Failed to start Jenkins service. Exiting..."
    exit 1
fi

# Configure firewall (if UFW is enabled)
if command -v ufw >/dev/null 2>&1 && sudo ufw status | grep -q "Status: active"; then
    echo "Configuring firewall for Jenkins..."
    sudo ufw allow 8080
    sudo ufw reload
fi

# Display Jenkins initial admin password
echo "Jenkins initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Display completion message
echo "Jenkins installation completed successfully!"
echo "Access Jenkins at http://<your-server-ip>:8080"
