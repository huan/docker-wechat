#!/usr/bin/env bash
set -eo pipefail

#
# Generate WeChat Version file by `peres` tool
#
WECHAT_DIR='/home/user/.wine/drive_c/Program Files/Tencent/WeChat'

peres -v "$WECHAT_DIR"/WeChatWin.dll | awk '{print $3}' > /home/VERSION.WeChat
echo 'WeChat VERSION generated'
