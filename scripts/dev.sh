#!/usr/bin/env bash

set -eo pipefail
set -x

#  --privileged \
  # --ipc=host \

DEVICE_ARG=()
for DEVICE in /dev/video* /dev/snd; do
  DEVICE_ARG+=('--device' "$DEVICE")
done

docker run \
  "${DEVICE_ARG[@]}" \
  --name wechat \
  --rm \
  -ti \
  \
  -v /WeChatFiles:/home/user/WeChatFiles \
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
  -p 22:22 \
  --entrypoint /bin/bash \
  --privileged \
  wechat
