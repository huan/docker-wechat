#!/usr/bin/env bash
set -eo pipefail

#
# Disable WeChat Upgrade - https://github.com/huan/docker-wechat/issues/29
#   1. In Wine: it seems that WeChat are using `Application Data` directory instead of `AppData`
#
PATCH_FILE_DIR_LIST=(
  '/home/user/.wine/drive_c/users/user/AppData/Roaming/Tencent/WeChat'
  '/home/user/.wine/drive_c/users/user/Application Data/Tencent/WeChat'
)
for dir in "${PATCH_FILE_DIR_LIST[@]}"; do
  echo "Disabling patch for $dir ..."
  mkdir -p "$dir"
  rm -fr "${dir}/patch"
  touch "${dir}/patch"
done

#
# 分析如何禁止微信自动更新
#   https://www.bilibili.com/video/av75595562/
#
if ! wine REG ADD 'HKEY_CURRENT_USER\Software\Tencent\WeChat' /v NeedUpdateType /t REG_DWORD /d 0 /f > /dev/null 2>&1; then
  >&2 echo 'FAIL: "reg add HKEY_CURRENT_USER\Software\Tencent\WeChat /v NeedUpdateType /d 0"'
fi

CONFIG_EX_INI_FILE='/home/user/.wine/drive_c/users/user/Application Data/Tencent/WeChat/All Users/config/configEx.ini'
if [ -e "$CONFIG_EX_INI_FILE" ]; then
  sed -i s/^NeedUpdateType=.*$/NeedUpdateType=0/i "$CONFIG_EX_INI_FILE"
fi
