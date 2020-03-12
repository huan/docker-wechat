#!/usr/bin/env bash

set -eo pipefail

function main () {
  ARTIFACT_IMAGE=$1

  IMAGE=$(cat IMAGE)
  TAG=$(cat VERSION)

  # https://stackoverflow.com/a/58453200/1123955
  WECHAT_VERSION=$(
    docker run --rm \
    -a stdout \
    --entrypoint cat \
    "$ARTIFACT_IMAGE" \
    /home/VERSION.WeChat
  )

  echo "Deploying IMAGE=$IMAGE"
  docker tag "${ARTIFACT_IMAGE}" "${IMAGE}:lastest"
  docker push "${IMAGE}:latest"

  echo "Deploying TAG=$TAG"
  docker tag "${ARTIFACT_IMAGE}" "${IMAGE}:${TAG}"
  docker push "${IMAGE}:${TAG}"

  echo "Deploying WECHAT_VERSION=$WECHAT_VERSION"
  docker tag "${ARTIFACT_IMAGE}" "${IMAGE}:${WECHAT_VERSION}"
  docker push "${IMAGE}:${WECHAT_VERSION}"
}

if [ -z "$1" ]; then
  >&2 echo "Missing argument: ARTIFACT_IMAGE"
  exit 1
fi

main "$1"
