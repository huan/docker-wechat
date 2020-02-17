#!/usr/bin/env bash

set -eo pipefail
set -x

#  --privileged \
  # --rm \

docker run \
  -ti \
  --name wechat \
  --entrypoint /bin/bash \
  wechat