#!/usr/bin/env bash

set -eo pipefail

[ -n "$DOCHAT_DEBUG" ] && set -x

#
# User Task
#
if [ "$(id -u)" -ne '0' ]; then
  if [ -n "$DOCHAT_DEBUG" ]; then
    wine reg query 'HKEY_CURRENT_USER\Software\Tencent\WeChat' || echo 'Register for Wechat not found ?'
    exec wine 'C:\Program Files\Tencent\WeChat\WeChat.exe'
  else
    exec wine 'C:\Program Files\Tencent\WeChat\WeChat.exe' 2> /dev/null
  fi
fi

#
# Root Init
#

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

export HOSTNAME=DoChat
echo "$HOSTNAME" > /etc/hostname

#
# Change the hostname for the wine runtime
# --privileged required
#
hostname "$HOSTNAME"

#
# Switch to user:group, and re-run self to run user task
#
exec gosu user:group "$0" "$@"
