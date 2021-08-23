#!/usr/bin/env bash
set -eo pipefail

#
# Download WeChat Installed Files
#
# HOME_TGZ_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.2.7.1.85.tgz
# HOME_TGZ_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.2.7.1.88.tgz
# HOME_TGZ_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.2.8.0.121.tgz
# HOME_TGZ_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.2.9.0.114.tgz
HOME_TGZ_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.3.3.0.115.tgz

curl -sL "$HOME_TGZ_URL" | tar zxf -
echo 'Artifacts Downloaded'
