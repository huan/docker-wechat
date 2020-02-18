#!/usr/bin/env bash

set -e
set -x

#
# User Task
#
if [ "$(id -u)" -ne '0' ]; then
  wine reg query 'HKEY_CURRENT_USER\Software\Tencent\WeChat' || true
  exec wine 'C:\Program Files\Tencent\WeChat\WeChat.exe'
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

# FileSavePath
chown user:group /WeChatFiles

# wine reg DELETE 'HKCU\Software\Tencent\WeChat' UpdateFailCnt /f &> /dev/null
# wine reg DELETE 'HKCU\Software\Tencent\WeChat' NeedUpdateType /f &> /dev/null
# rm "${WINEPREFIX}/drive_c/users/${USER}/Application Data/Tencent/WeChat/All Users/config/configEx.ini"

#
# Switch to user:group, and re-run self to run user task
#
exec gosu user:group "$0" "$@"
