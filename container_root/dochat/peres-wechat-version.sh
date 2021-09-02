#!/usr/bin/env bash
set -eo pipefail

#
# Generate WeChat Version file by `peres` tool
#
e
#
# Generate WeChat Version file
#   Product Version:                 3.3.0.115
#     -> 3.3.0.115
#
peres -v "$WECHAT_DIR"/WeChatWin.dll | grep 'Product Version: ' | awk '{print $3}' > /home/VERSION.WeChat
echo 'WeChat VERSION generated:'
cat /home/VERSION.WeChat
