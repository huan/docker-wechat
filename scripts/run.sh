#!/usr/bin/env bash

set -eo pipefail
set -x

OPTIONS=()

if [ -f /dev/snd ]; then
  OPTIONS+=('--device /dev/snd')
fi
if [ -f /dev/video0 ]; then
  OPTIONS+=('--device /dev/video0')
fi

docker run \
  "${OPTIONS[@]}" \
  --name DoChatDev \
  --rm \
  -ti \
  \
  -v "$HOME/DoChat/WeChat Files/":'/home/user/WeChat Files/' \
  -v "$HOME/DoChat/Applcation Data":'/home/user/.wine/drive_c/users/user/Application Data/' \
  \
  -e DISPLAY \
  -e DOCHAT_DEBUG \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  \
  -e XMODIFIERS=@im=fcitx \
  -e GTK_IM_MODULE=fcitx \
  -e QT_IM_MODULE=fcitx \
  -e AUDIO_GID="$(getent group audio | cut -d: -f3)" \
  -e VIDEO_GID="$(getent group video | cut -d: -f3)" \
  -e GID="$(id -g)" \
  -e UID="$(id -u)" \
  \
  --privileged \
  --ipc=host \
  \
  wechat
