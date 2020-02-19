#!/usr/bin/env bash

set -eo pipefail
set -x

#  --privileged \

docker run \
  --name wechat \
  --rm \
  -ti \
  \
  -v "$HOME/WeChat Files/":'/home/user/WeChat Files/' \
  \
  -e DISPLAY="$DISPLAY" \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  \
  --device /dev/snd \
  --device /dev/video0 \
  \
  -e XMODIFIERS=@im=fcitx \
  -e GTK_IM_MODULE=fcitx \
  -e QT_IM_MODULE=fcitx \
  -e AUDIO_GID="$(getent group audio | cut -d: -f3)" \
  -e VIDEO_GID="$(getent group video | cut -d: -f3)" \
  -e GID="$(id -g)" \
  -e UID="$(id -u)" \
  \
  wechat
