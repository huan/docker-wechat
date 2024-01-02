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

#
# The defeault docker image version which confirmed that most stable.
#   See: https://github.com/huan/docker-wechat/issues/29#issuecomment-619491488
#
# Updates:
#   2020-04-01: 2.7.1.85
#   2020-08-24: 3.3.0.115 (not working yet)
#   2020-09-01: 3.3.0.115 (alpha testing)

if [ "$EUID" -eq 0 ] && [ "${ALLOWROOT:-0}" -ne "1" ]
then
  echo "Please do not run this script as root."
  echo "see https://github.com/huan/docker-wechat/pull/209"
  exit 1
fi

DEFAULT_WECHAT_VERSION=3.3.0.115

#
# Get the image version tag from the env
#
DOCHAT_IMAGE_VERSION="docker.io/zixia/wechat:${DOCHAT_WECHAT_VERSION:-${DEFAULT_WECHAT_VERSION}}"

function hello () {
  cat <<'EOF'

       ____         ____ _           _
      |  _ \  ___  / ___| |__   __ _| |_
      | | | |/ _ \| |   | '_ \ / _` | __|
      | |_| | (_) | |___| | | | (_| | |_
      |____/ \___/ \____|_| |_|\__,_|\__|

      https://github.com/huan/docker-wechat

                +--------------+
               /|             /|
              / |            / |
             *--+-----------*  |
             |  |           |  |
             |  |   盒装    |  |
             |  |   微信    |  |
             |  +-----------+--+
             | /            | /
             |/             |/
             *--------------*

      DoChat /dɑɑˈtʃæt/ (Docker-weChat) is:

      📦 a Docker image
      🤐 for running PC Windows WeChat
      💻 on your Linux desktop
      💖 by one-line of command

EOF
}

function pullUpdate () {
  if [ -n "$DOCHAT_SKIP_PULL" ]; then
    return
  fi

  echo '🚀 Pulling the docker image...'
  echo
  podman pull "$DOCHAT_IMAGE_VERSION"
  echo
  echo '🚀 Pulling the docker image done.'
}

function main () {

  hello
  pullUpdate

  DEVICE_ARG=()
  for DEVICE in /dev/video*; do
    DEVICE_ARG+=('--device' "$DEVICE")
  done
  if [[ $(lshw -C display 2> /dev/null | grep vendor) =~ NVIDIA ]]; then
    DEVICE_ARG+=('--gpus' 'all' '--env' 'NVIDIA_DRIVER_CAPABILITIES=all')
  fi
  
  xhost +

  echo '🚀 Starting DoChat /dɑɑˈtʃæt/ ...'
  echo

  # Issue #111 - https://github.com/huan/docker-wechat/issues/111
  rm -f "$HOME/DoChat/Applcation Data/Tencent/WeChat/All Users/config/configEx.ini"

  # Issue #165 - https://github.com/huan/docker-wechat/issues/165#issuecomment-1643063633
  HOST_DIR_HOME_DOCHAT_WECHAT_FILES="$HOME/DoChat/WeChat Files/"
  HOST_DIR_HOME_DOCHAT_APPLICATION_DATA="$HOME/DoChat/Applcation Data/"
  mkdir "$HOST_DIR_HOME_DOCHAT_WECHAT_FILES" -p
  mkdir "$HOST_DIR_HOME_DOCHAT_APPLICATION_DATA" -p

  #
  # --privileged: enable sound (/dev/snd/)
  # --ipc=host:   enable MIT_SHM (XWindows)
  #
  podman run \
    "${DEVICE_ARG[@]}" \
    --name DoChat \
    --rm \
    -i \
    -u 0 \
    \
    -v "$HOST_DIR_HOME_DOCHAT_WECHAT_FILES":'/home/user/WeChat Files/' \
    -v "$HOST_DIR_HOME_DOCHAT_APPLICATION_DATA":'/home/user/.wine/drive_c/users/user/Application Data/' \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "/run/user/$(id -u)/pulse":"/run/pulse" \
    \
    -e DISPLAY \
    -e DOCHAT_DEBUG \
    -e DOCHAT_DPI \
    \
    -e XMODIFIERS \
    -e GTK_IM_MODULE \
    -e QT_IM_MODULE \
    \
    -e AUDIO_GID="$(getent group audio | cut -d: -f3)" \
    -e VIDEO_GID="$(getent group video | cut -d: -f3)" \
    -e GID="$(id -g)" \
    -e UID="$(id -u)" \
    \
    --ipc=host \
    --privileged \
    --add-host dldir1.qq.com:127.0.0.1 \
    --userns=keep-id \
    \
    "$DOCHAT_IMAGE_VERSION"

    #
    # Do not put any command between
    # the above "docker run" and
    # the below "echo"
    # because we need to output error code $?
    #
    echo "📦 DoChat Exited with code [$?]"
    echo
    echo '🐞 Bug Report: https://github.com/huan/docker-wechat/issues'
    echo

}

main
