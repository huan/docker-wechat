#!/usr/bin/env bash
set -eo pipefail

HOSTNAME=DoChat
echo "$HOSTNAME" > /etc/hostname

#
# Change the hostname for the wine runtime
# --privileged required
#
hostname "$HOSTNAME"
