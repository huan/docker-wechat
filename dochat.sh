#!/usr/bin/env bash
#
# dochat.sh - Docker WeChat for Linux
#
#   Author: Huan (李卓桓) <zixia@zixia.net>
#   Copyright (c) 2020-now
#
#   License: Apache-2.0
#   GitHub: https://github.com/huan/docker-wechat
#
set -eo pipefail

function hello () {
  cat <<'EOF'

       ____         ____ _           _
      |  _ \  ___  / ___| |__   __ _| |_
      | | | |/ _ \| |   | '_ \ / _` | __|
      | |_| | (_) | |___| | | | (_| | |_
      |____/ \___/ \____|_| |_|\__,_|\__|
    _________________________________________
   |\________________________________________\
   | | https://github.com/huan/docker-wechat |
    \|_______________________________________|

      DoChat /dɑɑˈtʃæt/ (Docker-weChat) is:

      📦 a Docker image
      🤐 for running Windows WeChat PC
      💻 on your Linux desktop
      💖 by one-line command

EOF
}

function update () {
  if [ -n "$DOCHAT_SKIP_UPDATE" ]; then
    return
  fi

  echo
  echo '🚀 Pulling the latest docker image...'
  echo
  docker pull zixia/wechat
  echo
  echo '🚀 Pulling the latest docker image done.'
  echo
}

function main () {
  DEVICE_ARG=()
  for DEVICE in /dev/video* /dev/snd; do
    DEVICE_ARG+=('--device' "$DEVICE")
  done

  echo
  echo '🚀 Starting DoChat /dɑɑˈtʃæt/ ...'
  echo

  #
  # --privileged: enable sound (/dev/snd/)
  # --ipc=host:   enable MIT_SHM (XWindows)
  #
  docker run \
    "${DEVICE_ARG[@]}" \
    --name DoChat \
    --rm \
    -i \
    \
    -v "$HOME/DoChat/WeChat Files/":'/home/user/WeChat Files/' \
    -v "$HOME/DoChat/Applcation Data":'/home/user/.wine/drive_c/users/user/Application Data/' \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    \
    -e DISPLAY="$DISPLAY" \
    -e DOCHAT_DEBUG="$DOCHAT_DEBUG" \
    \
    -e XMODIFIERS=@im=fcitx \
    -e GTK_IM_MODULE=fcitx \
    -e QT_IM_MODULE=fcitx \
    -e AUDIO_GID="$(getent group audio | cut -d: -f3)" \
    -e VIDEO_GID="$(getent group video | cut -d: -f3)" \
    -e GID="$(id -g)" \
    -e UID="$(id -u)" \
    \
    --ipc=host \
    --privileged \
    \
    zixia/wechat

    echo "📦 DoChat Exited with code [$?]"
    echo
    echo '🐞 Bug Report: https://github.com/huan/docker-wechat/issues'
    echo

}

hello
update
main
