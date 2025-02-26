#!/bin/bash

echo "Checking system requirements for macOS Ventura on WSL2..."
echo "========================================================="

# Check if running in WSL2
if [[ $(uname -r) =~ Microsoft$ ]] || [[ $(uname -r) =~ microsoft-standard$ ]]; then
    echo "✅ Running in WSL2"
else
    echo "❌ Not running in WSL2. This script must be run within WSL2."
    exit 1
fi

# Check WSL2 kernel version
kernel_version=$(uname -r | cut -d'-' -f1)
if [[ $(echo "$kernel_version 5.10.16" | awk '{if ($1 >= $2) print "yes"; else print "no"}') == "yes" ]]; then
    echo "✅ WSL2 kernel version $kernel_version is sufficient"
else
    echo "❌ WSL2 kernel version $kernel_version is below recommended 5.10.16"
    echo "   Consider updating your WSL2 kernel"
fi

# Check CPU virtualization
if grep -q -E 'vmx|svm' /proc/cpuinfo; then
    echo "✅ CPU virtualization is enabled"
else
    echo "❌ CPU virtualization not detected. Please enable VT-x/AMD-V in your BIOS"
    exit 1
fi

# Check KVM availability
if [ -e /dev/kvm ]; then
    if [ -r /dev/kvm ] && [ -w /dev/kvm ]; then
        echo "✅ KVM is available and accessible"
    else
        echo "❌ KVM is available but not accessible. Run: sudo chmod 666 /dev/kvm"
    fi
else
    echo "❌ KVM is not available. Check if virtualization is enabled in BIOS"
    exit 1
fi

# Check available RAM
total_ram=$(free -m | awk '/^Mem:/{print $2}')
if [ "$total_ram" -ge 7500 ]; then
    echo "✅ RAM: $total_ram MB (sufficient)"
else
    echo "❌ RAM: $total_ram MB (insufficient, 8GB or more recommended)"
    echo "   Consider increasing RAM allocation to WSL2"
fi

# Check available disk space
free_space=$(df -h . | awk 'NR==2 {print $4}')
echo "ℹ️ Available disk space: $free_space (50GB+ recommended)"

# Check Docker installation
if command -v docker &> /dev/null; then
    docker_version=$(docker --version | awk '{print $3}' | sed 's/,//')
    echo "✅ Docker is installed (version $docker_version)"
    
    # Check if Docker daemon is running
    if sudo systemctl is-active --quiet docker; then
        echo "✅ Docker daemon is running"
    else
        echo "❌ Docker daemon is not running. Start with: sudo systemctl start docker"
    fi
    
    # Check if user is in docker group
    if groups | grep -q docker; then
        echo "✅ User is in the docker group"
    else
        echo "❌ User is not in the docker group. Run: sudo usermod -aG docker $USER"
        echo "   Then log out and back in for changes to take effect"
    fi
else
    echo "❌ Docker is not installed. Install with: sudo apt install docker.io"
    exit 1
fi

# Check for required packages
echo "Checking for required packages..."
missing_packages=()

for pkg in tasksel xfce4 gtk2-engines; do
    if ! dpkg -l | grep -q "ii  $pkg "; then
        missing_packages+=("$pkg")
    fi
done

if [ ${#missing_packages[@]} -eq 0 ]; then
    echo "✅ All required packages are installed"
else
    echo "❌ Missing packages: ${missing_packages[*]}"
    echo "   Install with: sudo apt install -y ${missing_packages[*]}"
fi

# Check X11 configuration
if grep -q "export DISPLAY=" ~/.bashrc; then
    echo "✅ X11 display configuration found in .bashrc"
else
    echo "❌ X11 display configuration not found in .bashrc"
    echo "   Add the following lines to your ~/.bashrc:"
    echo "   export DISPLAY=\$(cat /etc/resolv.conf | grep nameserver | awk '{print \$2; exit;}'):0.0"
    echo "   export LIBGL_ALWAYS_INDIRECT=1"
fi

echo "========================================================="
echo "System requirements check completed." 