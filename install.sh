#! /usr/bin/bash

# example: INSTALL_PREFIX=/usr ./install_meson.sh

# ---------------- Install build_master_meson ----------------------

# Platform detection
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "mingw"* ]]; then
	PLATFORM="MINGW"
else
	PLATFORM="LINUX"
fi

# Make sure pyinstaller is available
if ! command -v pyinstaller &> /dev/null; then
	echo "pyinstaller not avaiable, installing it using pip"
	pip install --break-system-packages pyinstaller
fi

# Make sure certifi package is installed
if ! pip show certifi > /dev/null 2>&1; then
	echo "certifi not installed, installing it using pip"
	pip install --break-system-packages certifi
fi

# Package meson into one executable
(pyinstaller --onefile --runtime-hook=runtime_hook.py --add-data "$(python -m certifi):certifi" --add-data "mesonbuild:mesonbuild" meson.py)

if [ -z $INSTALL_PREFIX ]; then
	INSTALL_PREFIX="/usr"
fi

# Copy the executable to the install directory
if [[ "$PLATFORM" == "MINGW" ]]; then
    echo "Copying dist/meson.exe to ${INSTALL_PREFIX}/bin/build_master_meson.exe"
    cp dist/meson.exe "${INSTALL_PREFIX}/bin/build_master_meson.exe"
else
    echo "Copying dist/meson to ${INSTALL_PREFIX}/bin/build_master_meson"
    cd $CLONE_PATH && cp dist/meson "${INSTALL_PREFIX}/bin/build_master_meson"
fi
