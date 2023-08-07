
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
