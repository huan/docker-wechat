#!/usr/bin/env bash
set -eo pipefail

#
# Generate WeChat Version file by `peres` tool
#
#   Product Version:                 3.3.0.115
#     -> 3.3.0.115
#
WECHAT_DIR='/home/user/.wine/drive_c/Program Files/Tencent/WeChat'

peres -v "$WECHAT_DIR"/WeChatWin.dll | grep 'Product Version: ' | awk '{print $3}' > /home/VERSION.WeChat
echo 'WeChat VERSION generated:'
cat /home/VERSION.WeChat
