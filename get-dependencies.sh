#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm mpv webkit2gtk-4.1

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini webkit2gtk-4.1-mini

echo "Getting binary..."
echo "---------------------------------------------------------------"

# case "$ARCH" in
# 	x86_64)  farch=x64;;
# 	aarch64) farch=arm;;
# esac

if [ "${DEVEL_RELEASE-}" = 1 ]; then
    RELEASE=$(curl -fsSL https://api.github.com/repos/namidaco/namida-snapshots/releases/latest)
else
    # RELEASE=$(curl -fsSL https://api.github.com/repos/namidaco/namida/releases/latest)
    RELEASE=$(curl -fsSL https://api.github.com/repos/namidaco/namida-snapshots/releases/latest)
fi

echo "$RELEASE" | jq -r '.tag_name' > ~/version
link=$(echo "$RELEASE" | jq -r '.assets[] | select(.name | endswith(".linux.tar.gz")) | select(.name | contains("_login") | not) | .browser_download_url')

mkdir -p ./AppDir/bin
curl -sSfL --retry 30 --retry-connrefused "$link" -o /tmp/temp.tar.gz
tar -xvzf /tmp/temp.tar.gz -C ./AppDir/bin

# upstream binaries are lacking the executable bit
chmod +x ./AppDir/bin/bin/*

cp -v ./AppDir/bin/share/icons/hicolor/512x512/apps/namida.png ./AppDir
cp -v ./AppDir/bin/share/applications/com.msob7y.namida.desktop ./AppDir
