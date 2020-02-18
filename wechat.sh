#!/usr/bin/env bash

set -eo pipefail

DOCKER_ARGS=()

if [ -f /dev/snd ]; then
  DOCKER_ARGS+=('--device /dev/snd')
fi
if [ -f /dev/video0 ]; then
  DOCKER_ARGS+=('--device /dev/video0')
fi

docker run \
  "${DOCKER_ARGS[@]}" \
  --name wechat \
  --rm \
  -i \
  \
  -v "$HOME/WeChatFiles:/WeChatFiles" \
  \
  -e DISPLAY="$DISPLAY" \
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
  zixia/wechat
