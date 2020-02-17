# docker-wechat [![Docker](https://github.com/huan/docker-wechat/workflows/Docker/badge.svg)](https://github.com/huan/docker-wechat/actions?query=workflow%3ADocker)

[![dockeri.co](https://dockeri.co/image/zixia/wechat)](https://hub.docker.com/r/zixia/wechat/)

![Docker Wechat](https://huan.github.io/docker-wechat/images/docker-wechat.png)

> Image Credit: [Docker 101](https://www.docker.com/blog/docker-101-introduction-docker-webinar-recap/) + [Icon Finder](https://www.iconfinder.com/icons/4539886/application_chat_communication_wechat_wechat_logo_icon)

A Docker Image for Running Windows WeChat on Your Linux Desktop

## Features

1. Developed & Tested under Ubuntu 19.10
1. Display Chinese Characters
1. Input Chinese Characters
1. Paste Images to WeChat

## Usage

### For Human

This is the easist way to run Wechat PC on your Linux Box:

```sh
curl -sL https://raw.githubusercontent.com/huan/docker-wechat/master/wechat.sh | bash
```

Just copy / paste the above one line command to your terminal, and press Enter. Then WeChat PC should appear in your XWindows desktop shortly.

### For Hard Core Hackers

If you want to control everything by yourself, for example: you want to open multiple WeChat PC client on your desktop, then you might want to learn the [wechat.sh](https://github.com/huan/docker-wechat/blob/master/wechat.sh) in our repository.

You can also try to run the following docker command:

```sh
docker run \
  --name wechat \
  --rm \
  -i \
  \
  -v "$HOME/WeChatFiles:/WeChatFiles" \
  \
  -e DISPLAY="unix$DISPLAY" \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  \
  --device /dev/snd \
  --device /dev/video0 \
  \
  -e XMODIFIERS=@im=fcitx \
  -e GTK_IM_MODULE=fcitx \
  -e QT_IM_MODULE=fcitx \
  -e AUDIO_GID="$(getent group audio | cut -d: -f3)" \
  -e VIDEO_GID="$(getent group video | cut -d: -f3)" \
  -e GID="$(id -g)" \
  -e UID="$(id -u)" \
  \
  zixia/wechat
```

## FAQ

### System Tray Icon with Gnome Desktop

Install Gnome Extension: [Top Icons Plus Git](https://extensions.gnome.org/extension/2311/topicons-plus/)

## Links

- [Input Method don't work when using X11Forward](https://ubuntuforums.org/showthread.php?t=913752)
- [Input method related environment variables](https://fcitx-im.org/wiki/Input_method_related_environment_variables)
- [Docker GUI最佳实践](https://github.com/zjZSTU/Containerization-Automation/blob/982d54458b05ef75fe6436f4ea72bbb66c4cb931/docs/docker/gui/%5BDocker%5DGUI最佳实践.md)
- [Linux 下 完美运行 wechat](https://www.kpromise.top/run-wechat-in-linux/)

## History

### master

### v0.1 (Feb 17, 2020)

1. Inited.

## Thanks

1. [基于深度操作系统的微信 docker 镜像](https://github.com/bestwu/docker-wechat) by [@bestwu](https://github.com/bestwu)

## Author

[Huan LI](https://github.com/huan) ([李卓桓](http://linkedin.com/in/zixia)) zixia@zixia.net

[![Profile of Huan LI (李卓桓) on StackOverflow](https://stackexchange.com/users/flair/265499.png)](https://stackexchange.com/users/265499)

## Copyright & License

- Code & Docs © 2020-now Huan LI \<zixia@zixia.net\>
- Code released under the Apache-2.0 License
- Docs released under Creative Commons
