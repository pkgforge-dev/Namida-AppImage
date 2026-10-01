#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export MAIN_BIN=./AppDir/bin/namida
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"

# Upstream ships a mostly static ffmpeg and ffprobe binary
# get rid of them and use the ffmpeg binaries from archlinux
# this way we share the same libavcodec between all of them
rm -f ./AppDir/bin/bin/ffmpeg ./AppDir/bin/bin/ffprobe

# Deploy dependencies
quick-sharun ./AppDir/bin/* /usr/bin/ffmpeg /usr/bin/ffprobe /usr/lib/libmpv.so* /usr/lib/libwebkit2gtk-4.1.so*

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
