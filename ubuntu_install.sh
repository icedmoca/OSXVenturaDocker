
#!/bin/bash

# Update and upgrade system packages
sudo apt update && sudo apt upgrade -y

# Install necessary packages within Ubuntu
echo "Installing required packages..."
sudo apt install -y tasksel xubuntu-desktop gtk2-engines docker.io

# Setup Docker
echo "Setting up Docker..."
sudo systemctl enable docker
sudo systemctl start docker

# Add current user to docker group to avoid using sudo with docker commands
sudo usermod -aG docker $USER

# Configure .bashrc for GUI
echo "Configuring .bashrc for GUI support..."
echo "export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0" >> ~/.bashrc
echo "export LIBGL_ALWAYS_INDIRECT=1" >> ~/.bashrc
echo "sudo /etc/init.d/dbus start &> /dev/null" >> ~/.bashrc

# Note for the user about VcXsrv Windows X Server
echo "Please manually install VcXsrv Windows X Server for GUI support as mentioned in the README."

# Run macOS Ventura using Docker (assuming user has set up Docker for WSL2)
echo "Running macOS Ventura using Docker in WSL2..."
docker run \
--device /dev/kvm \
-e AUDIO_DRIVER=pa,server=unix:/tmp/pulseaudio.socket \
-v /mnt/wslg/runtime-dir/pulse/native:/tmp/pulseaudio.socket \
-v /mnt/wslg/.X11-unix:/tmp/.X11-unix \
sickcodes/docker-osx:ventura

echo "Installation and setup completed!"
