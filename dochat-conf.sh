#!/usr/bin/env bash

set -eo pipefail

#
# Export the wechat dochat configuration params to override the defaults.
#

#
# Docker image parameters
#
export DEFAULT_WECHAT_VERSION=2.7.1.85
export DEFAULT_DOCKER_IMAGE_BASE="zixia/wechat"

#
# Override commandline input if wanted
#
# export DOCHAT_WECHAT_VERSION=2.7.1.85
# export DOCHAT_SKIP_PULL=true
