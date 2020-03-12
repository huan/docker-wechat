#!/usr/bin/env bash

set -eo pipefail

#
# Install SemVer Bash Tool
#
SEMVER_BIN=/usr/local/bin/semver

sudo curl -sL \
  -o "$SEMVER_BIN" \
  https://raw.githubusercontent.com/fsaintjacques/semver-tool/3.0.0/src/semver

sudo chmod +x "$SEMVER_BIN"

#
# Install Bats
#
curl -sSL \
  -o /tmp/bats_v0.4.0.tar.gz \
  https://github.com/sstephenson/bats/archive/v0.4.0.tar.gz
tar -xf /tmp/bats_v0.4.0.tar.gz
sudo bats-0.4.0/install.sh /usr/local
