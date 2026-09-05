#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm mpv wpewebkit

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Getting binary..."
echo "---------------------------------------------------------------"

case "$ARCH" in
	x86_64)  farch=x64;;
	aarch64) farch=arm;;
esac

if [ "${DEVEL_RELEASE-}" = 1 ]; then
    RELEASE=$(curl -fsSL https://api.github.com/repos/namidaco/namida-snapshots/releases/latest)
else
    exit 1
fi

echo "$RELEASE" | jq -r '.tag_name' > ~/version
link=$(echo "$RELEASE" | jq -r '.assets[] | select(.name | endswith(".linux.tar.gz")) | select(.name | contains("_login") | not) | .browser_download_url')

curl -sSfL --retry 30 --retry-connrefused "$link" -o /tmp/temp.tar.gz

mkdir -p ./AppDir/
tar -xvzf /tmp/temp.tar.gz -C ./AppDir/

# THIS SHOULDN'T BE EVEN NECESSARY ACCORDING TO THEIR README.md BUT ITS BROKEN
login_link=$(echo "$RELEASE" | jq -r '.assets[] | select(.name | endswith("_login.linux.tar.gz")) | .browser_download_url')

curl -sSfL --retry 30 --retry-connrefused "$login_link" -o /tmp/login.tar.gz

tar -xvzf /tmp/login.tar.gz -C ./AppDir/ ./lib/libflutter_inappwebview_linux_plugin.so
