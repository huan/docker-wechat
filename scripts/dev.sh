#!/usr/bin/env bash

set -eo pipefail
set -x

#  --privileged \
  # --ipc=host \

OPTIONS=()

if [ -f /dev/snd ]; then
  OPTIONS+=('--device /dev/snd')
fi
if [ -f /dev/video0 ]; then
  OPTIONS+=('--device /dev/video0')
fi

docker run \
  "${OPTIONS[@]}" \
  --name wechat \
  --rm \
  -ti \
  \
  -v /WeChatFiles:"$HOME/WeChatFiles" \
  \
  -e DISPLAY="unix$DISPLAY" \
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
  -p 22:22 \
  --entrypoint /bin/bash \
  wechat
