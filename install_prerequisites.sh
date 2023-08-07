
#!/bin/bash

# Check if WSL2 is running
if [[ $(uname -r) =~ Microsoft$ ]]; then
    echo "WSL2 detected."
else
    echo "This script should be run within WSL2. Exiting."
    exit 1
fi

# Install Docker (assuming Docker for WSL2 is set up)
echo "Setting up Docker..."
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

# Add current user to docker group to avoid using sudo with docker commands
sudo usermod -aG docker $USER

# Install necessary packages within WSL2
echo "Installing required packages..."
sudo apt-get install -y tasksel xubuntu-desktop gtk2-engines

# Prompt for VcXsrv Windows X Server
echo "Please manually install VcXsrv Windows X Server from the provided link in the README."

echo "Prerequisites installation completed!"

