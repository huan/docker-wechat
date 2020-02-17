#!/usr/bin/env bash

set -e
set -x

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
chown user:group /WechatFiles

# wine reg DELETE 'HKCU\Software\Tencent\WeChat' UpdateFailCnt /f &> /dev/null
# wine reg DELETE 'HKCU\Software\Tencent\WeChat' NeedUpdateType /f &> /dev/null
# rm "${WINEPREFIX}/drive_c/users/${USER}/Application Data/Tencent/WeChat/All Users/config/configEx.ini"

su user -c "wine reg QUERY 'HKEY_CURRENT_USER\Software\Tencent\WeChat'"
su user -c "wine 'C:\Program Files\Tencent\WeChat\WeChat.exe'"
