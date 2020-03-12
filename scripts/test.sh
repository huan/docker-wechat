#!/usr/bin/env bats

@test "VERSION should match SemVer(x.y.z)" {
  VERSION=$(cat VERSION)
  [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

@test "IMAGE should match account/name" {
  IMAGE=$(cat IMAGE)
  [[ "$IMAGE" =~ ^[a-z0-9_]+/[a-z0-9_]+$ ]]
}
