#!/usr/bin/env bash

set -eo pipefail

# 1.2.3
# 2.3.4
function isRelease () {
  minor=$(semver get minor "$1")
  mod2=$((minor%2))
  # echo "isRelease: $1 minor $minor release $release"
  return $mod2
}
