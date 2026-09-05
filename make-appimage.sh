#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export MAIN_BIN=./AppDir/namida
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=./AppDir/share/icons/namida_256.png
export DESKTOP=./AppDir/share/applications/namida.desktop

echo 'WEBKIT_INJECTED_BUNDLE_PATH=${SHARUN_DIR}/lib' >> ./AppDir/.env

quick-sharun ./AppDir/namida ./AppDir/bin/* /usr/lib/wpe-webkit-2.0/WPE*Process /usr/lib/wpe-webkit-2.0/injected-bundle/libWPEInjectedBundle.so
quick-sharun --make-appimage
