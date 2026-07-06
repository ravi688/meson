#! /usr/bin/bash

# example: INSTALL_PREFIX=/usr ./install_meson.sh

set -e

# ---------------- Install build_master_meson ----------------------

# Platform detection
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "mingw"* ]]; then
	PLATFORM="MINGW"
else
	PLATFORM="LINUX"
        if [[ "$INSTALL_PREFIX" = /usr/* ]] && [ "$EUID" -ne 0 ]; then
                echo "This script must be run as root. Please use sudo."
                exit -1
        fi

        is_in_docker() {
                [ -f "/.dockerenv" ] || grep -qa docker /proc/1/cgroup
        }

        # Detect if we are running on docker container
        if is_in_docker || [ -z "${SUDO_USER-}" ]; then
                NO_ROOT=""
        else
                NO_ROOT="sudo -u $SUDO_USER"
        fi
fi

# Make sure python is available
if command -v python >/dev/null 2>&1; then
    echo "Python is already installed."
else
    echo "Python not found. Installing..."
    apt-get update
    apt-get install -y python3
    apt-get install -y python-is-python3
fi

# Make sure pyinstaller is available
if ! command -v pyinstaller &> /dev/null; then
	echo "pyinstaller not avaiable, installing it using pip"
	if command -v pip >/dev/null 2>&1; then
    		echo "pip is already installed."
	else
    		echo "pip not found. Installing..."
		apt-get update
		apt-get install -y python3-pip
	fi
	pip install --break-system-packages pyinstaller
fi

# Make sure certifi package is installed
if ! pip show certifi > /dev/null 2>&1; then
	echo "certifi not installed, installing it using pip"
	pip install --break-system-packages certifi
fi

# On Proxmox containers, the path /usr/local/bin is not added to PATH variable by default
export PATH=$PATH:/usr/local/bin
# Package meson into one executable
$NO_ROOT pyinstaller --onefile --clean --runtime-hook=runtime_hook.py --add-data "$(python -m certifi):certifi" --add-data "mesonbuild:mesonbuild" meson.py

if [ -z $INSTALL_PREFIX ]; then
	INSTALL_PREFIX="/usr"
fi

# Copy the executable to the install directory
if [[ "$PLATFORM" == "MINGW" ]]; then
    echo "Copying dist/meson.exe to ${INSTALL_PREFIX}/bin/build_master_meson.exe"
    cp dist/meson.exe "${INSTALL_PREFIX}/bin/build_master_meson.exe"
else
    echo "Copying dist/meson to ${INSTALL_PREFIX}/bin/build_master_meson"
    cp dist/meson "${INSTALL_PREFIX}/bin/build_master_meson"
fi
