#!/usr/bin/env bats

source ./scripts/is-release.sh

@test "VERSION should match SemVer(x.y.z)" {
  VERSION=$(cat VERSION)
  [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

@test "IMAGE should match account/name" {
  IMAGE=$(cat IMAGE)
  [[ "$IMAGE" =~ ^[a-z0-9_]+/[a-z0-9_]+$ ]]
}

@test "isRelease for release minor version" {
  RELEASE_VERSION='1.2.3'
  isRelease "$RELEASE_VERSION"
}

@test "isRelease for developing minor version" {
  DEV_VERSION='2.3.4'
  ! isRelease "$DEV_VERSION"
}
