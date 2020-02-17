#!/usr/bin/env bash

set -e

docker images | grep -e '^<none>       *<none>       '  | awk '{print $3}' | xargs docker rmi