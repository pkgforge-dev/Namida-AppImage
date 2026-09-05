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

export PATH_MAPPING='
/usr/lib/wpe-webkit-2.0/WPENetworkProcess:${SHARUN_DIR}/lib/WPENetworkProcess
/usr/lib/wpe-webkit-2.0/WPEWebProcess:${SHARUN_DIR}/lib/WPEWebProcess
/usr/lib/wpe-webkit-2.0/WPEGPUProcess:${SHARUN_DIR}/lib/WPEGPUProcess
/usr/lib/wpe-webkit-2.0/injected-bundle/libWPEInjectedBundle.so:${SHARUN_DIR}/lib/libWPEInjectedBundle.so
'

quick-sharun ./AppDir/namida ./AppDir/bin/*

chmod +x \
	./AppDir/lib/WPENetworkProcess \
	./AppDir/lib/WPEWebProcess \
	./AppDir/lib/WPEGPUProcess

quick-sharun --make-appimage
