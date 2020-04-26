#!/usr/bin/env bash
set -eo pipefail

if [ -n "$AUDIO_GID" ]; then
  groupmod -o -g "$AUDIO_GID" audio
fi
if [ -n "$VIDEO_GID" ]; then
  groupmod -o -g "$VIDEO_GID" video
fi
if [ "$GID" != "$(id -g user)" ]; then
    groupmod -o -g "$GID" group
fi
if [ "$UID" != "$(id -u user)" ]; then
    usermod -o -u "$UID" user
fi

chown user:group \
  '/home/user/.wine/drive_c/users/user/Application Data' \
  '/home/user/WeChat Files'
