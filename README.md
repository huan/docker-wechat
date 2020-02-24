# DoChat /dɑɑˈtʃæt/ 盒装微信 [![Docker](https://github.com/huan/docker-wechat/workflows/Docker/badge.svg)](https://github.com/huan/docker-wechat/actions?query=workflow%3ADocker)

[![dockeri.co](https://dockeri.co/image/zixia/wechat)](https://hub.docker.com/r/zixia/wechat/)

DoChat(盒装微信) is a Dockerized WeChat(微信) PC Windows Client for Linux.

![DoChat](https://huan.github.io/docker-wechat/images/dochat.png)

> Image Credit: [Docker 101](https://www.docker.com/blog/docker-101-introduction-docker-webinar-recap/) + [Icon Finder](https://www.iconfinder.com/icons/4539886/application_chat_communication_wechat_wechat_logo_icon), and Ps-ed by Ruoxin Song

## Honors

- [Tweeted](https://twitter.com/newsycombinator/status/1231489594765594625) by Y Combinator [Hacker News](https://news.ycombinator.com/item?id=22395507)

## Usage ![Powered Ubuntu](https://img.shields.io/badge/WeChat-Ubuntu-orange)

WeChat PC will be started on your Linux desktop by running the following one-line command:

```sh
curl -sL https://raw.githubusercontent.com/huan/docker-wechat/master/dochat.sh | bash
```

Just copy/paste the above one-line command to your terminal and press Enter. Then the WeChat PC should appear in your XWindows desktop shortly.

![DoChat Term Command](https://huan.github.io/docker-wechat/images/term-dochat.jpg)

## Features

It just works out-of-the-box with one-line of shell command!

1. Input/Display Chinese characters perfectly.
1. Paste copied images to WeChat with `Ctrl+V`

![DoChat Screenshot](https://huan.github.io/docker-wechat/images/screenshot-dochat.jpg)

## Requirements

1. Ubuntu Linux desktop (DoChat was developed under Ubuntu 19.10 desktop, should be ok with 19.04/18.10/18.04, might be ok with other Linux distributions)
1. Docker (run `sudo apt update && apt install docker.io` to install Docker for Ubuntu users)

## Environment Variables

### `DOCHAT_SKIP_UPDATE`

If you do not want to update docker image at startup everytime, you can set `DOCHAT_SKIP_UPDATE` environment variable.

```sh
curl -sL https://raw.githubusercontent.com/huan/docker-wechat/master/dochat.sh \
  | DOCHAT_SKIP_UPDATE=true bash
```

In case you have downloaded `dochat.sh`:

```sh
DOCHAT_SKIP_UPDATE=true ./dochat.sh
```

### `DOCHAT_DEBUG`

Show more debug log messages.

```sh
curl -sL https://raw.githubusercontent.com/huan/docker-wechat/master/dochat.sh \
  | DOCHAT_DEBUG=true bash
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
  \
  -e DISPLAY="$DISPLAY" \
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

## Known Issues

- [ ] In-WeChat Browser does not work ([#2](https://github.com/huan/docker-wechat/issues/2))

## To-do List

- [x] Permanent Storage for WeChat PC Login Data Information ([#3](https://github.com/huan/docker-wechat/issues/3))
- [ ] Automatically install WeChat PC from .EXE installer when building the Dockerfile. (Test Automation tools might be needed)
- [ ] Monitor WeChat PC version publications so that we can publish the same version number of the docker image with it.

## FAQ

### 1 System Tray Icon with Gnome Desktop

Install Gnome Extension: [Top Icons Plus Git](https://extensions.gnome.org/extension/2311/topicons-plus/)

## Links

- [Input Method don't work when using X11Forward](https://ubuntuforums.org/showthread.php?t=913752)
- [Input method related environment variables](https://fcitx-im.org/wiki/Input_method_related_environment_variables)
- [Docker GUI最佳实践](https://github.com/zjZSTU/Containerization-Automation/blob/982d54458b05ef75fe6436f4ea72bbb66c4cb931/docs/docker/gui/%5BDocker%5DGUI最佳实践.md)
- [Linux 下 完美运行 wechat 微信](https://www.kpromise.top/run-wechat-in-linux/)

## History

### master

### v0.4 (Feb 21, 2020)

Got a great logo from my art friend Ruoxin SONG.

1. Fix Sound ([#1](https://github.com/huan/docker-wechat/issues/1))
1. Fix to not exit during the upgrading progress.

### v0.2 (Feb 18, 2020)

The first working version, cheers!

### v0.1 (Feb 17, 2020)

Project created.

## Thanks

1. [基于深度操作系统的微信 docker 镜像](https://github.com/bestwu/docker-wechat) by [@bestwu](https://github.com/bestwu)
1. DoChat logo designed by my friend Ruoxin SONG.

## Author

[Huan LI](https://github.com/huan) ([李卓桓](http://linkedin.com/in/zixia)) zixia@zixia.net

[![Profile of Huan LI (李卓桓) on StackOverflow](https://stackexchange.com/users/flair/265499.png)](https://stackexchange.com/users/265499)

## Copyright & License

- Code & Docs © 2020-now Huan LI \<zixia@zixia.net\>
- Code released under the Apache-2.0 License
- Docs released under Creative Commons
