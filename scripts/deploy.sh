#!/usr/bin/env bash

set -eo pipefail

source scripts/is-release.sh

function deployWechatVersion () {
  # https://stackoverflow.com/a/58453200/1123955
  WECHAT_VERSION=$(
    docker run --rm \
    -a stdout \
    --entrypoint cat \
    "$ARTIFACT_IMAGE" \
    /home/VERSION.WeChat
  )

  echo "Deploying WECHAT_VERSION=$WECHAT_VERSION"
  docker tag "${ARTIFACT_IMAGE}" "${IMAGE}:${WECHAT_VERSION}"
  docker push "${IMAGE}:${WECHAT_VERSION}"
}

function deployVersion () {
  SEMVER_MAJOR=$(semver get major "$VERSION")
  SEMVER_MINOR=$(semver get minor "$VERSION")

  TAG="$SEMVER_MAJOR.$SEMVER_MINOR"

  echo "Deploying TAG=$TAG"
  docker tag "${ARTIFACT_IMAGE}" "${IMAGE}:${TAG}"
  docker push "${IMAGE}:${TAG}"
}

function deployLatest () {
  echo "Deploying IMAGE=$IMAGE latest"
  docker tag "${ARTIFACT_IMAGE}" "${IMAGE}:latest"
  docker push "${IMAGE}:latest"
}

function main () {
  if [ -z "$1" ]; then
    >&2 echo -e "Missing argument.\nUsage: $0 ARTIFACT_IMAGE"
    exit 1
  fi

  ARTIFACT_IMAGE=$1

  IMAGE=$(cat IMAGE)
  VERSION=$(cat VERSION)

  deployWechatVersion
  deployVersion

  if isRelease "$VERSION"; then
    deployLatest
    echo "$VERSION set to latest"
  fi
}

main "$@"
