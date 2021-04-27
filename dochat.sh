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

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#
# The defeault docker image version which confirmed that most stable.
#   See: https://github.com/huan/docker-wechat/issues/29#issuecomment-619491488
#
function loadDefaults () {
	if [ -z ${DEFAULT_WECHAT_VERSION+x} ]; then 
		DEFAULT_WECHAT_VERSION=2.7.1.85
	fi
	if [ -z ${DEFAULT_DOCKER_IMAGE_BASE+x} ]; then 
		DEFAULT_DOCKER_IMAGE_BASE="zixia/wechat"
	fi
}

#
# look for the dochat-conf.sh and load it if we can to override the default params
#
if [ -x "$SCRIPT_DIR/dochat-conf.sh" ]; then
	source "$SCRIPT_DIR/dochat-conf.sh"
else
	echo "BS"
fi

loadDefaults

#
# Get the image version tag from the env
#
DOCHAT_IMAGE_VERSION="$DEFAULT_DOCKER_IMAGE_BASE:${DOCHAT_WECHAT_VERSION:-${DEFAULT_WECHAT_VERSION}}"

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
  docker pull "$DOCHAT_IMAGE_VERSION"
  echo
  echo '🚀 Pulling the docker image done.'
}

function main () {
  hello
  pullUpdate

  DEVICE_ARG=()
  for DEVICE in /dev/video* /dev/snd; do
    DEVICE_ARG+=('--device' "$DEVICE")
  done

  echo '🚀 Starting DoChat /dɑɑˈtʃæt/ ...'
  echo

  rm -f "$HOME/DoChat/Applcation Data/Tencent/WeChat/All Users/config/configEx.ini"

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
    \
    "$DOCHAT_IMAGE_VERSION"

    echo
    echo "📦 DoChat Exited with code [$?]"
    echo
    echo '🐞 Bug Report: https://github.com/huan/docker-wechat/issues'
    echo

}

main
