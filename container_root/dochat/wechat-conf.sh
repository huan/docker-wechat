#!/usr/bin/env bash

set -eo pipefail

#
# Export the wechat artifact configuration params to override the defaults.
# "$DOCHAT_WECHAT_URI_BASE/$DOCHAT_WECHAT_FILE_PRE$DOCHAT_WECHAT_VERSION.$DOCHAT_WECHAT_FILE_EXT"
# is the pattern we are building in the /dochat/install-wechat.sh file
#
# Defaults are loaded in /dochat/install-wechat.sh
#
# The defaults are: 
# DOCHAT_WECHAT_VERSION_LATEST="2.9.0.114"
# DOCHAT_WECHAT_VERSION_DEFAULT="$DOCHAT_WECHAT_LATEST"
# DOCHAT_WECHAT_URI_BASE="https://github.com/huan/docker-wechat/releases/download/v0.1"
# DOCHAT_WECHAT_FILE_PRE="home."
# DOCHAT_WECHAT_FILE_EXT="tgz"
#
# The DOCHAT_WECHAT_VERSION used is dynamically determined via the $DOCKER_TAG env var in /dochat/install-wechat.sh
# This allows us to batch auto build with hub.docker.com triggered by a single github commit 
#

export DOCHAT_WECHAT_VERSION_LATEST="2.9.0.114"
export DOCHAT_WECHAT_VERSION_DEFAULT="$DOCHAT_WECHAT_VERSION_LATEST"
export DOCHAT_WECHAT_URI_BASE="https://github.com/huan/docker-wechat/releases/download/v0.1"
export DOCHAT_WECHAT_FILE_PRE="home."
export DOCHAT_WECHAT_FILE_EXT="tgz"
