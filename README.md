
## Installation Guide for WSL2 and MacOS Ventura
How to install macOS Ventura on Windows 11 using WSL2, QEMU, and Docker.


Based off [/sickcodes/Docker-OSX](https://github.com/sickcodes/Docker-OSX)

| OS          | Info                                                                 |
| ----------- | -------------------------------------------------------------------- |
| Windows 11  | Recommended                                                          |
| Windows 10  | Possible Dependency Issues                                           |

## Prerequisites:
1. **Windows Operating System:** Windows 10 or Windows 11.
2. **WSL2:** Ensure WSL2 is installed and set up properly. If not, refer to [Microsoft's official guide](https://docs.microsoft.com/en-us/windows/wsl/install).
3. **Docker for WSL2:** You'll need Docker set up within your WSL2 environment to run the macOS Ventura image.
4. **VcXsrv Windows X Server:** Required for GUI capabilities within WSL2.
5. **Packages to Install within WSL2:**
   - **tasksel:** A software installation application that comes with the Debian installer. It's used to install multiple related packages as a coordinated "task" onto your system.
   - **xubuntu-desktop:** Provides the Xubuntu desktop environment, a lightweight environment for UNIX-like operating systems based on the XFCE desktop environment.
   - **gtk2-engines:** Provides engines for the GTK2 toolkit, used to render the user interface for various themes.

```
curl -o install_prerequisites.sh https://raw.githubusercontent.com/icedmoca/OSXVenturaDocker/main/install_prerequisites.sh && chmod +x install_prerequisites.sh && ./install_prerequisites.sh
```

##
## Installing WSL2 on Windows 10/11

### Setup WSL2:
1. Ensure that you are running Windows 10 or Windows 11.
2. Setup WSL2 properly (e.g., using Ubuntu 20.04 LTS as your WSL2 distribution). [WSL install guide](https://docs.microsoft.com/en-us/windows/wsl/install).

### Configure WSL2 for GUI and macOS Ventura:
1. Open your WSL2 instance (e.g., Ubuntu).
2. Execute the following commands to install the required packages:
```
sudo apt install -y tasksel
sudo tasksel install xubuntu-desktop
sudo apt install gtk2-engines
```
3. Switch to the root user and edit the .bashrc file using a text editor like vim or nano:

``` 
vim ~/.bashrc 
```

``` 
nano ~/.bashrc 
```

4. Add the following lines to the end of the file:
```
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
export LIBGL_ALWAYS_INDIRECT=1
sudo /etc/init.d/dbus start &> /dev/null
```
5. Save and exit the editor.

### Install and Configure X Server for Windows:
1. Download and install [VcXsrv Windows X Server](https://sourceforge.net/projects/vcxsrv/).
2. During the installation:
   - Choose the `Multiple windows` display option.
   - Keep the default settings on the subsequent screen.
   - On the next window, ensure `all options are selected`, including 'Disable access control'. Save the configuration if you wish.

## Run macOS Ventura using Docker in WSL2:
1. In your WSL2 instance, execute the following command to run macOS Ventura using Docker:
* Note: You may have to change the directory /mnt/wslg/ depending on your system, the ending is wslg
```
docker run \
--device /dev/kvm \
-e AUDIO_DRIVER=pa,server=unix:/tmp/pulseaudio.socket \
-v /mnt/wslg/runtime-dir/pulse/native:/tmp/pulseaudio.socket \
-v /mnt/wslg/.X11-unix:/tmp/.X11-unix \
sickcodes/docker-osx:ventura
```

Follow these steps sequentially after setting up WSL2 to have a fully functional macOS Ventura environment within your Windows system.

## Troubleshooting Common Issues

### Docker Issues

1. **"Cannot connect to the Docker daemon" error**
   - Ensure Docker service is running: `sudo systemctl start docker`
   - Verify your user is in the docker group: `groups | grep docker`
   - If not in group, run: `sudo usermod -aG docker $USER` and then log out and back in

2. **KVM not available error**
   - Ensure KVM is enabled in your BIOS/UEFI settings
   - Check if KVM is available: `ls -la /dev/kvm`
   - If permission denied: `sudo chmod 666 /dev/kvm`

3. **Docker image pull failure**
   - Check your internet connection
   - Try with explicit version tag: `sickcodes/docker-osx:ventura-latest`
   - If Docker Hub is rate-limiting you, try authenticating: `docker login`

### Display/GUI Issues

1. **Black screen or no display**
   - Ensure VcXsrv is running with "Disable access control" checked
   - Verify DISPLAY environment variable: `echo $DISPLAY`
   - Try restarting the X server and your WSL instance

2. **Graphical glitches or poor performance**
   - Reduce the resolution in the macOS settings
   - Ensure your GPU drivers are up to date
   - Allocate more resources to WSL2 (see WSL config file)

### Audio Issues

1. **No sound**
   - Verify the PulseAudio socket path is correct
   - Check if PulseAudio is running in WSL: `pactl info`
   - Try reinstalling PulseAudio: `sudo apt install --reinstall pulseaudio`

### macOS Boot Issues

1. **Stuck at boot screen**
   - Be patient, first boot can take 10+ minutes
   - Try increasing RAM allocation to the Docker container
   - Check Docker logs: `docker logs <container_id>`

2. **Installation loop or recovery mode**
   - Ensure you're using the correct Docker image version
   - Try with a different macOS version (e.g., Big Sur instead of Ventura)
   - Check if your CPU supports the required virtualization features

   ## Version Compatibility Information

### Windows Requirements
- **Windows 10**: Version 2004 (Build 19041) or higher
- **Windows 11**: Any version (recommended)

### WSL2 Requirements
- WSL2 kernel version 5.10.16 or higher (check with `uname -r`)
- Ubuntu 20.04 LTS or Ubuntu 22.04 LTS recommended
- Minimum 8GB RAM allocated to WSL2
- Minimum 4 CPU cores allocated to WSL2

### Docker Requirements
- Docker Engine 20.10.x or higher
- Docker Desktop for Windows with WSL2 backend enabled

### VcXsrv Requirements
- VcXsrv version 1.20.9.0 or higher

### Hardware Requirements
- CPU with virtualization support (Intel VT-x or AMD-V)
- Minimum 16GB system RAM (32GB recommended)
- At least 50GB free disk space
- SSD storage recommended for better performance

### macOS Ventura Compatibility
- Works best with sickcodes/docker-osx:ventura (tag version 11.0 or higher)
- Requires at least 4GB RAM allocated to the Docker container
- Performance improves significantly with 8GB+ RAM allocation