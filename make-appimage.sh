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

quick-sharun ./AppDir/namida ./AppDir/bin/* ./AppDir/lib/wpe-webkit-2.0/* /usr/lib/wpe-webkit-2.0/injected-bundle/libWPEInjectedBundle.so
quick-sharun --make-appimage
