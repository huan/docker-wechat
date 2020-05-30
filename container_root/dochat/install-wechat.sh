#!/usr/bin/env bash
# This script defaults to HOME_TGZ_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.2.9.0.114.tgz
# if not actively overridden by vars in /dochat/wechat-conf.sh or via build param $DOCKER_TAG


set -eo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# function to load the default values if the vars are unset
function loadDefaults () {
	if [ -z ${DOCHAT_WECHAT_VERSION_LATEST+x} ]; then 
		DOCHAT_WECHAT_LATEST="2.9.0.114"
	fi
	if [ -z ${DOCHAT_WECHAT_VERSION_DEFAULT+x} ]; then
		DOCHAT_WECHAT_DEFAULT=$DOCHAT_WECHAT_LATEST
	fi
	if [ -z ${DOCHAT_WECHAT_URI_BASE+x} ]; then
		DOCHAT_WECHAT_URI_BASE="https://github.com/huan/docker-wechat/releases/download/v0.1"
	fi
	if [ -z ${DOCHAT_WECHAT_FILE_PRE+x} ]; then
		DOCHAT_WECHAT_FILE_PRE="home."
	fi
	if [ -z ${DOCHAT_WECHAT_FILE_EXT+x} ]; then
		DOCHAT_WECHAT_FILE_EXT="tgz"
	fi
}


# look for the /dochat/wechat-conf.sh and load it if we can to overide the default params
if [ -x "$SCRIPT_DIR/wechat-conf.sh" ]; then
	source $SCRIPT_DIR/wechat-conf.sh
fi

loadDefaults

DOCHAT_WECHAT_VERSION=$DOCHAT_WECHAT_VERSION_DEFAULT

# since set in the Dockerfile we need to test if DOCKER_TAG is empty not if its unset
if [ -n "${DOCKER_TAG}" ]; then
	if [ "$DOCKER_TAG" == "2.7.1.85" ]; then
		DOCHAT_WECHAT_VERSION="2.7.1.85"
	elif [ "$DOCKER_TAG" == "2.7.1.88" ]; then
		DOCHAT_WECHAT_VERSION="2.7.1.88"
	elif [ "$DOCKER_TAG" == "2.8.0.121" ]; then
		DOCHAT_WECHAT_VERSION="2.8.0.121"
	elif [ "$DOCKER_TAG" == "2.9.0.114" ]; then
		DOCHAT_WECHAT_VERSION="2.9.0.114"
	elif [ "$DOCKER_TAG" == "latest" ]; then
		DOCHAT_WECHAT_VERSION=$DOCHAT_WECHAT_VERSION_LATEST
	fi
fi 

HOME_TGZ_URL="$DOCHAT_WECHAT_URI_BASE/$DOCHAT_WECHAT_FILE_PRE$DOCHAT_WECHAT_VERSION.$DOCHAT_WECHAT_FILE_EXT"

#
# To manually override the automatic setting of the URL uncomment the line for the desired version
#
# HOME_TGZ_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.2.7.1.85.tgz
# HOME_TGZ_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.2.7.1.88.tgz
# HOME_TGZ_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.2.8.0.121.tgz
# HOME_TGZ_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.2.9.0.114.tgz

curl -sL "$HOME_TGZ_URL" | tar zxf -
echo 'Artifacts Downloaded'
