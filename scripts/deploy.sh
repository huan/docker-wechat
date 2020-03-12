#!/usr/bin/env bash

set -eo pipefail

source scripts/is-release.sh

function main () {
  ARTIFACT_IMAGE=$1

  IMAGE=$(cat IMAGE)
  VERSION=$(cat VERSION)

  # https://stackoverflow.com/a/58453200/1123955
  WECHAT_VERSION=$(
    docker run --rm \
    -a stdout \
    --entrypoint cat \
    "$ARTIFACT_IMAGE" \
    /home/VERSION.WeChat
  )

  echo "Deploying IMAGE=$IMAGE latest"
  docker tag "${ARTIFACT_IMAGE}" "${IMAGE}:latest"
  docker push "${IMAGE}:latest"

  echo "Deploying WECHAT_VERSION=$WECHAT_VERSION"
  docker tag "${ARTIFACT_IMAGE}" "${IMAGE}:${WECHAT_VERSION}"
  docker push "${IMAGE}:${WECHAT_VERSION}"

  if isRelease "$VERSION"; then
    echo "Deploying VERSION(tag)=$VERSION"
    docker tag "${ARTIFACT_IMAGE}" "${IMAGE}:${VERSION}"
    docker push "${IMAGE}:${VERSION}"
  else
    echo "$VERSION is not a release version, skipped."
  fi
}

if [ -z "$1" ]; then
  >&2 echo "Missing argument: ARTIFACT_IMAGE"
  exit 1
fi

main "$1"

