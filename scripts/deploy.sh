#!/usr/bin/env bash

set -eo pipefail

source scripts/is-release.sh

function getWechatVersion () {
  # https://stackoverflow.com/a/58453200/1123955
  docker run --rm \
    -a stdout \
    --entrypoint cat \
    "$ARTIFACT_IMAGE" \
    /home/VERSION.WeChat
}

function main () {
  if [ -z "$1" ]; then
    >&2 echo -e "Missing argument.\nUsage: $0 ARTIFACT_IMAGE"
    exit 1
  fi

  ARTIFACT_IMAGE=$1

  IMAGE=$(cat IMAGE)
  VERSION=$(cat VERSION)

  WECHAT_VERSION=$(getWechatVersion)
  echo "Detected WECHAT_VERSION=$WECHAT_VERSION"

  SEMVER_MAJOR=$(semver get major "$VERSION")
  SEMVER_MINOR=$(semver get minor "$VERSION")
  TAG="$SEMVER_MAJOR.$SEMVER_MINOR"

  TAG_ARGS=()
  TAG_ARGS+=("-t" "${IMAGE}:${WECHAT_VERSION}")
  TAG_ARGS+=("-t" "${IMAGE}:${TAG}")

  if isRelease "$VERSION"; then
    TAG_ARGS+=("-t" "${IMAGE}:latest")
    echo "$VERSION set to latest"
  fi

  echo "Building and deploying multi-arch (linux/amd64, linux/arm64) images..."
  docker buildx build \
    --platform linux/amd64,linux/arm64 \
    "${TAG_ARGS[@]}" \
    --push \
    .
}

main "$@"
