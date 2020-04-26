#!/usr/bin/env bash
set -eo pipefail

#
# Download WeChat Installed Files
#
# HOME_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.2.9.0.114.tgz
# HOME_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.2.8.0.121.tgz
# HOME_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.2.7.1.88.tgz
HOME_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.2.7.1.85.tgz
curl -sL "$HOME_URL" | tar zxf -
echo 'Artifacts Downloaded'

#
# Generate WeChat Version file by `peres` tool
#
WECHAT_DIR='/home/user/.wine/drive_c/Program Files/Tencent/WeChat'
pushd "$WECHAT_DIR"
  peres -v WeChatWin.dll | awk '{print $3}' > /home/VERSION.WeChat
  echo 'WeChat VERSION generated'
popd

#
# Setup WeChat in Windows Registry
#
wine regedit.exe /s /tmp/wechat-install.reg
wine reg query 'HKEY_CURRENT_USER\Software\Tencent\WeChat'
echo 'Regedit Initialized'
# FIXME: reg set success or not ???
wine reg query 'HKEY_CURRENT_USER\Software\Tencent\WeChat' || echo 'Graceful FAIL. REG NOT FOUND'

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
