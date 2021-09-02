#!/usr/bin/env bash

set -eo pipefail

[ -n "$DOCHAT_DEBUG" ] && set -x

function hello () {
  VERSION=$(cat /VERSION)
  echo "[DoChat] 盒装微信 v$VERSION"
}

function setupFontDpi () {
  #
  # Wine Screen Resolution (DPI Setting)
  #   https://wiki.winehq.org/Winecfg#Screen_Resolution_.28DPI_Setting.29
  #
  DELETE_KEYS=('HKEY_CURRENT_USER\Control Panel\Desktop' 'HKEY_CURRENT_USER\Software\Wine\Fonts')

  for key in "${DELETE_KEYS[@]}"; do
    wine reg DELETE "$key" /v LogPixels /f > /dev/null 2>&1 || true
  done

  wine reg ADD \
    'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Hardware Profiles\Current\Software\Fonts' \
    /v LogPixels \
    /t REG_DWORD \
    /d "${DOCHAT_DPI:-120}" \
    /f \
    > /dev/null 2>&1
}

#
# WeChat
#
function startWechat () {

  hello
  setupFontDpi

  /dochat/patch-hosts.sh
  /dochat/disable-upgrade.sh

  if [ -n "$DOCHAT_DEBUG" ]; then
    unset WINEDEBUG
    wine reg query 'HKEY_CURRENT_USER\Software\Tencent\WeChat' || echo 'Register for Wechat not found ?'
    echo "[DoChat] DISPLAY=$DISPLAY"
  fi

  VERSION=$(head -1 /home/VERSION.WeChat)
  echo "[DoChat] WeChat $VERSION"

  while true; do
    echo '[DoChat] Starting...'

    if [ -n "$DOCHAT_DEBUG" ]; then
      wine 'C:\Program Files\Tencent\WeChat\WeChat.exe'
    else
      if ! wine 'C:\Program Files\Tencent\WeChat\WeChat.exe'; then
        echo "[DoChat] WeChat.exe exit with code $?"
        echo "[DoChat] Found new version?"
      fi
    fi

    #
    # WeChat.exe will run background after an upgrade.
    # Check if it exists, and wait it exit.
    #
    while true; do
      if [ -n "$(pgrep -i WeChat.exe)" ]; then
        sleep 1
      else
        echo '[DoChat] WeChat.exe exited'
        break
      fi
    done

    #
    # Wait until it finish
    #   if there's a running upgrading process
    #
    unset upgrading
    while true; do
      # pgrep returns nothing if the pattern length is longer than 15 characters
      # https://askubuntu.com/a/813214/375372
      # WeChatUpdate.exe -> WeChatUpdate.ex
      if [ -z "$(pgrep -i WeChatUpdate.ex)" ]; then
        echo
        break
      fi

      if [ -z "$upgrading" ]; then
        echo -n '[DoChat] Upgrading...'
        upgrading=true
      fi

      echo -n .
      sleep 1

    done

    # if it's not upgrading, then quit upgrading check loop
    if [ -z "$upgrading" ]; then
      break
    fi

    # go to loop beginning and restart wine again.
  done
}

#
# Main
#
function main () {

  if [ "$(id -u)" -ne '0' ]; then
    startWechat
  else
    /dochat/set-user-group.sh
    /dochat/set-hostname.sh
    #
    # Switch to user:group, and re-run self to run user task
    #
    exec gosu user "$0" "$@"
  fi
}

main "$@"
