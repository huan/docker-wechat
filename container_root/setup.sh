#!/usr/bin/env bash
set -eo pipefail

bash -x /dochat/install-wechat.sh
bash -x /dochat/peres-wechat-version.sh
bash -x /dochat/regedit.sh
bash -x /dochat/disable-upgrade.sh
