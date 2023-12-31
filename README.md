# DoChat /dɑɑˈtʃæt/ 盒装微信

[![Docker](https://github.com/huan/docker-wechat/workflows/Docker/badge.svg)](https://github.com/huan/docker-wechat/actions?query=workflow%3ADocker)
[![Powered By Wine](https://img.shields.io/badge/Powered%20By-Wine-red)](https://www.winehq.org/)

[![dockeri.co](https://dockeri.co/image/zixia/wechat)](https://hub.docker.com/r/zixia/wechat/tags)

DoChat(盒装微信) is a Dockerized WeChat(微信) PC Windows Client for Linux.

![DoChat](https://huan.github.io/docker-wechat/images/dochat.png)

> Image Credit: [Docker 101](https://www.docker.com/blog/docker-101-introduction-docker-webinar-recap/) + [Icon Finder](https://www.iconfinder.com/icons/4539886/application_chat_communication_wechat_wechat_logo_icon), and Ps-ed by Ruoxin Song

## Honors

- [Tweeted](https://twitter.com/newsycombinator/status/1231489594765594625) by Y Combinator [Hacker News](https://news.ycombinator.com/item?id=22395507)
- [Headlined](https://huan.github.io/docker-wechat/images/oschina-feb-25-2020.png) by [OS China](https://www.oschina.net/)

## Disclaimer

We have received reports from our user said that their WeChat account has been disabled after using this project, so use it at your own risk:

1. [昨天用了一下最新版的docker镜像立马微信就被封了 #55](https://github.com/huan/docker-wechat/issues/55)

## Usage ![Powered Linux](https://img.shields.io/badge/WeChat-Linux-brightgreen)

WeChat PC will be started on your Linux desktop by running the following one-line command:

```sh
curl -sL https://raw.githubusercontent.com/huan/docker-wechat/master/dochat.sh | bash
```

If you’re in China, try the following one-line command if the above one-line command does not work well:
```sh
curl -sL https://gitee.com/mirrors/dochat/raw/main/dochat.sh | bash
```

Just copy/paste the above one-line command to your terminal and press Enter. Then the WeChat PC should appear in your XWindows desktop shortly.

![DoChat Term Command](https://huan.github.io/docker-wechat/images/term-dochat.png)

### Attention

The [dochat.sh](https://github.com/huan/docker-wechat/blob/master/dochat.sh) script must not be with uid 0 (root user). Running it with uid 0 will lead to an infinite loop
that is hard to kill from the terminal. If your user doesn't have the right to run docker please add the user to the docker group `sudo usermod -aG docker $USER`.
 A reboot might be neccessary for the changes to take place.

The issue is described in [#60](https://github.com/huan/docker-wechat/issues/60).

## Features

It just works out-of-the-box with one-line of shell command!

1. Input/Display Chinese characters perfectly.
1. Paste copied images to WeChat with `Ctrl+V`

![DoChat Screenshot](https://huan.github.io/docker-wechat/images/screenshot-dochat.png)

## Requirements

1. Linux Ubuntu distribution will be recommended (DoChat was developed with the Ubuntu Desktop 19.10)
    1. Debian support confirmed ([#9](https://github.com/huan/docker-wechat/issues/9))
    1. OpenSUSE Leap 15.1 support confirmed ([#16](https://github.com/huan/docker-wechat/issues/16))
    1. OpenSUSE Tumbleweed support confirmed ([#150](https://github.com/huan/docker-wechat/issues/150))
    1. Arch support confirmed ([#26](https://github.com/huan/docker-wechat/issues/26))
    1. Ubuntu(19.04/18.10/18.04) should be able to support
    1. Linux Mint 21.2 Cinnamon support confirmed ([#215](https://github.com/huan/docker-wechat/issues/215))
    1. Other Linux distributions: might be able to support
1. Docker (run `sudo apt update && apt install docker.io` to install Docker for Ubuntu users)
1. [`nvidia-container-toolkit`](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) may be installed ([#173](https://github.com/huan/docker-wechat/issues/173))

## Environment Variables

### `DOCHAT_DPI`

DPI Scale Factors for graphic screen resolution.

| DPI  | Scale factor |
| ---: | :---: |
|  96 | 100% |
| 120 | 125% |
| 144 | 150% |
| 192 | 200% |

Default: `120`

To enlarge the window & fonts size:

```sh
curl -sL https://raw.githubusercontent.com/huan/docker-wechat/master/dochat.sh \
  | DOCHAT_DPI=192 bash
```

### `DOCHAT_SKIP_PULL`

If you do not want to pull docker image for the latest version at startup everytime, you can set `DOCHAT_SKIP_PULL` environment variable.

```sh
curl -sL https://raw.githubusercontent.com/huan/docker-wechat/master/dochat.sh \
  | DOCHAT_SKIP_PULL=true bash
```

In case you have downloaded `dochat.sh`:

```sh
DOCHAT_SKIP_PULL=true ./dochat.sh
```

### `DOCHAT_DEBUG`

Show more debug log messages.

```sh
curl -sL https://raw.githubusercontent.com/huan/docker-wechat/master/dochat.sh \
  | DOCHAT_DEBUG=true bash
```

### `DOCHAT_WECHAT_VERSION`

Use a specific version for WeChat.

You can get a full list of the supported versions from Docker Hub Image Tags at <https://hub.docker.com/r/zixia/wechat/tags>

For example:

```sh
curl -sL https://raw.githubusercontent.com/huan/docker-wechat/master/dochat.sh \
  | DOCHAT_WECHAT_VERSION=3.3.0.115 bash
```

## For Hackers

If you want to control everything by yourself, for example, open multiple WeChat PC client on your desktop; then, you might want to inspect the [dochat.sh](https://github.com/huan/docker-wechat/blob/master/dochat.sh) in our repository and try the following docker command:

```sh
docker run \
  --name DoChat \
  --rm \
  -i \
  \
  -v "$HOME/DoChat/WeChat Files/":'/home/user/WeChat Files/' \
  -v "$HOME/DoChat/Applcation Data":'/home/user/.wine/drive_c/users/user/Application Data/' \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v "/run/user/$(id -u)/pulse":"/run/pulse" \
  \
  -e DISPLAY \
  \
  -e XMODIFIERS=@im=fcitx \
  -e GTK_IM_MODULE=fcitx \
  -e QT_IM_MODULE=fcitx \
  -e GID="$(id -g)" \
  -e UID="$(id -u)" \
  \
  --ipc=host \
  --privileged \
  \
  zixia/wechat
```

Modify it whatever you want to fulfill your needs.

## Versioning

The docker image has two schema of the versioning:

1. `X.Y.Z.a`: This is for the WeChat PC Windows Client version
    1. `zixia/wechat:2.7.1.85`: WeChat 2.7.1.85
    1. `zixia/wechat:2.8.0.112`: WeChat 2.8.0.112
1. `x.y`: This is for the docker image version.
    1. `zixia/wechat:0.2`: docker-wechat version 0.2

The two version schema may overlap with each other.

For example: the `zixia/wechat:0.2` may be the same image as the `zixia/wechat:2.8.0.112`.

## Known Issues

- [ ] WeChat 2.8.0.x can not send big images/files ([#341](https://github.com/huan/docker-wechat/issues/31))
  - Work around: use [2.7.1.85](https://hub.docker.com/layers/zixia/wechat/2.7.1.85/images/sha256-e6e9d21c7cd1dfae0484e697f12f5f3c401de2f02e771d061868740e0d26549d) instead. (`DOCHAT_WECHAT_VERSION=2.7.1.85`)
- [ ] In-WeChat Browser does not work ([#2](https://github.com/huan/docker-wechat/issues/2))

## To-do List

- [x] Permanent Storage for WeChat PC Login Data Information ([#3](https://github.com/huan/docker-wechat/issues/3))
- [ ] Automatically install WeChat PC from .EXE installer when building the Dockerfile. (Test Automation tools might be needed)
- [ ] Monitor WeChat PC version publications so that we can publish the same version number of the docker image with it.
- [ ] Resolve the infinite loop situation when running with uid 0 ([#60](https://github.com/huan/docker-wechat/issues/60))
- [ ] New feature: wechat_pc_api， <https://github.com/huan/docker-wechat/issues/125>

## FAQ

### System Tray Icon with Gnome Desktop

Install Gnome Extension: [Top Icons Plus Git](https://extensions.gnome.org/extension/2311/topicons-plus/) by bijignome

> Note 1: there's almost half dozen of the `TopIcons` extensions with very similar name: TopIcons, TopIcons Redux, TopIcons Plus, **TopIcons Plus Git**, TopIconsFix. Use **TopIcons Plus Git**, it's the right one.  
>
> Note 2: The `TopIcons Plus` has the bug that cause the `wine` itself shows a window on your desktop. ([#19](https://github.com/huan/docker-wechat/issues/19))

### Exit with code 5 on openSUSE Leap

When you encounter problem that the app exit with code 5  on openSUSE Leap, you need to disable X server access control to allow any user to connect to the X server before you start the app. Use below command to disable it:  

`$ xhost +`

### OpenSUSE Tumbleweed Configurations

To address the issue ([#150](https://github.com/huan/docker-wechat/issues/150)) do the following: (Thanks [Wu Bo](https://github.com/bo-wu))

`$ xhost +; sudo chown -R $USER $HOME/DoChat/`

### No main window after start up with 2 or more monitor setup

This could be caused by an old bug in wine with multiple monitor setup. Workaround is to start it up with single monitor and then switch to multiple monitors

This behavior may cause the view disappear when you use the Join Displays mode, so you need change the mode to mirrors when the app start, this script may help:

```Bash
#bin/bash
xrandr --output HDMI-1-2 --same-as eDP-1-1

curl -sL https://raw.githubusercontent.com/huan/docker-wechat/master/dochat.sh \
  | DOCHAT_SKIP_PULL=true bash &

sleep 5
xrandr --output HDMI-1-2 --right-of eDP-1-1
```

Change the HDMI-1-2 to your external display name and eDP-1-1 to your built in display name. Display more than two, link to [this](http://www.mikewootc.com/wiki/linux/usage/set_x_reso.html).

***Notice***: you must drag the login dialog to built in display side when the process sleep 5, otherwise the view may stuck in the external display.

## Links

- [Input Method don't work when using X11Forward](https://ubuntuforums.org/showthread.php?t=913752)
- [Input method related environment variables](https://fcitx-im.org/wiki/Input_method_related_environment_variables)
- [Docker GUI最佳实践](https://github.com/zjZSTU/Containerization-Automation/blob/982d54458b05ef75fe6436f4ea72bbb66c4cb931/docs/docker/gui/%5BDocker%5DGUI最佳实践.md)
- [Linux 下 完美运行 wechat 微信](https://www.kpromise.top/run-wechat-in-linux/)
- [WeChat Desktop on Linux](https://ferrolho.github.io/blog/2018-12-22/wechat-desktop-on-linux)

## History

### master v0.14

1. Update to WeChat version 3.3.0.115 ([#131](https://github.com/huan/docker-wechat/issues/131))
1. Upgrade to Wine version 6.0
1. Upgrade to Debian 11 (bullseye)
1. Rename default branch from `master` to `main`

### v0.10 (Mar 12, 2020)

1. Upgrade wine from v4.0 to v5.0
1. Deploy to Docker Hub by GitHub Actions with Automatic WeChat Version Number.

### v0.8 (Mar 3, 2020)

1. Add a new configuration environment variable `DOCHAT_WECHAT_VERSION` to select WeChat version.
1. Add WeChat v2.8.0.112
    1. 新增订阅号浏览
    1. 新增IPv6网络支持
    1. 新增看一看精选内容
    1. 新增打开聊天中小程序消息
    1. 新增在小程序中使用微信支付
    1. 新增聊天文件面板，可查看和管理所有聊天文件

```sh
curl -sL https://raw.githubusercontent.com/huan/docker-wechat/master/dochat.sh \
  | DOCHAT_WECHAT_VERSION=2.8.0.112 bash
```

### v0.5 (Feb 24, 2020)

1. Add environment variable `DOCHAT_DPI` to set DPI scale factors for graphicg screen resolution.
1. Disable auto-update.

### v0.4 (Feb 21, 2020)

Got a great logo from my art friend Ruoxin SONG.

1. Fix Sound ([#1](https://github.com/huan/docker-wechat/issues/1))
1. Fix to not exit during the upgrading progress.

### v0.2 (Feb 18, 2020)

The first working version, cheers!

### v0.1 (Feb 17, 2020)

Project created.

## Thanks

1. [WeChat Desktop on Linux](https://ferrolho.github.io/blog/2018-12-22/wechat-desktop-on-linux) - by [@ferrolho](https://github.com/ferrolho)
1. [Wine HQ App Database - WeChat](https://appdb.winehq.org/objectManager.php?sClass=application&iId=16931)
1. [基于深度操作系统的微信 docker 镜像](https://github.com/bestwu/docker-wechat) by [@bestwu](https://github.com/bestwu)
1. DoChat logo designed by my friend Ruoxin SONG.

## Related Projects

1. [DoWork /dɑɑˈwɜːk/ 盒装企业微信](https://github.com/huan/docker-wxwork): Dockerized WeChat Work (企业微信) PC Windows Client for Linux
1. Put your WeChat in the box: <https://github.com/ChisBread/wechat-box>

## Contributors

[![contributor](https://sourcerer.io/fame/huan/huan/docker-wechat/images/0)](https://sourcerer.io/fame/huan/huan/docker-wechat/links/0)
[![contributor](https://sourcerer.io/fame/huan/huan/docker-wechat/images/1)](https://sourcerer.io/fame/huan/huan/docker-wechat/links/1)
[![contributor](https://sourcerer.io/fame/huan/huan/docker-wechat/images/2)](https://sourcerer.io/fame/huan/huan/docker-wechat/links/2)
[![contributor](https://sourcerer.io/fame/huan/huan/docker-wechat/images/3)](https://sourcerer.io/fame/huan/huan/docker-wechat/links/3)
[![contributor](https://sourcerer.io/fame/huan/huan/docker-wechat/images/4)](https://sourcerer.io/fame/huan/huan/docker-wechat/links/4)
[![contributor](https://sourcerer.io/fame/huan/huan/docker-wechat/images/5)](https://sourcerer.io/fame/huan/huan/docker-wechat/links/5)
[![contributor](https://sourcerer.io/fame/huan/huan/docker-wechat/images/6)](https://sourcerer.io/fame/huan/huan/docker-wechat/links/6)
[![contributor](https://sourcerer.io/fame/huan/huan/docker-wechat/images/7)](https://sourcerer.io/fame/huan/huan/docker-wechat/links/7)

## Author

[Huan Li](https://github.com/huan) ([LinkedIn](http://linkedin.com/in/huan42)) Tencent TVP of Chatbot.

[![Profile of Huan LI (李卓桓) on StackOverflow](https://stackexchange.com/users/flair/265499.png)](https://stackexchange.com/users/265499)

## Copyright & License

- Code & Docs © 2020-now Huan Li \<huan@chatie.io\>
- Code released under the Apache-2.0 License
- Docs released under Creative Commons
