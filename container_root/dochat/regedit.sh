#!/usr/bin/env bash
set -eo pipefail

tmpRegFile=$(mktemp /tmp/regedit.XXXXXXXXX.reg)
trap 'rm -f "$tmpRegFile"' EXIT

cat <<_EOF_ > "$tmpRegFile"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Tencent\WeChat]
"ChannelId"=dword:000003e8
"Version"=dword:62070155
"InstallPath"="C:\\Program Files\\Tencent\\WeChat"
"LANG_ID"=dword:00000009
"CrashVersion"=dword:62070155
"CrashCnt"=dword:00000000
"NeedUpdateType"=dword:00000000
"UpdateFailCnt"="1644626309;3"
_EOF_

#
# Setup WeChat in Windows Registry
#
wine regedit.exe /s "$tmpRegFile"
wine reg query 'HKEY_CURRENT_USER\Software\Tencent\WeChat'
echo 'Regedit Initialized'
# FIXME: reg set success or not ???
wine reg query 'HKEY_CURRENT_USER\Software\Tencent\WeChat' || echo 'Graceful FAIL. REG NOT FOUND'
