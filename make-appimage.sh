#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export MAIN_BIN=./AppDir/bin/namida
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=./AppDir/bin/share/icons/namida_256.png
export DESKTOP=./AppDir/bin/share/applications/namida.desktop

echo "WEBKIT_DISABLE_SANDBOX_THIS_IS_DANGEROUS=1" >> ./AppDir/.env

quick-sharun ./AppDir/bin/* /usr/lib/wpe-webkit-2.0
quick-sharun --make-appimage
