
#
# Stage 1: Builder
#
FROM ubuntu:eoan as Builder

ARG DEBIAN_FRONTEND=noninteractive

ENV LANG='C.UTF-8' \
  LC_ALL='C.UTF-8' \
  WINEDEBUG=-all

RUN dpkg --add-architecture i386 \
  && echo 'i386 Architecture Added'

RUN apt-get update \
  && apt-get install -y \
    wine32:i386 \
    winetricks:amd64 \
    \
    # https://github.com/wszqkzqk/deepin-wine-ubuntu/issues/188#issuecomment-554599956
    ttf-wqy-microhei \
    ttf-wqy-zenhei \
    xfonts-wqy \
    \
    apt-transport-https:amd64 \
    ca-certificates:amd64 \
    cabextract:amd64 \
    curl:amd64 \
    gosu \
    language-pack-zh-hans \
    tzdata:amd64 \
    unzip:amd64 \
    wget:amd64 \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -fr /tmp/*

RUN groupadd group \
  && useradd -m -g group user \
  && chsh -s /bin/bash user \
  && echo 'User created'

COPY --chown=user:group ./container_root/ /

ARG HOME_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.tgz
RUN curl -sL "$HOME_URL" | tar zxf - \
  && chown -R user.group /home/user \
  && echo 'Artifacts: downlaoded'

RUN su user -c 'WINEARCH=win32 wine wineboot' \
  \
  && echo 'quiet=on' > /etc/wgetrc \
  && su user -c 'winetricks -q win7' \
  && su user -c 'winetricks -q riched20' \
  && rm -rf /etc/wgetrc \
  \
  && su user -c "wine regedit.exe /s '/home/user/.wine/drive_c/Program Files/Tencent/WeChat/install.reg'" \
  && rm -rf /home/user/.cache/ /home/user/tmp/* \
  && echo "Wine: initialized"

ENV \
  LANG=zh_CN.UTF-8 \
  LC_ALL=zh_CN.UTF-8 \
  TZ=Asia/Shanghai

ENTRYPOINT [ "/entrypoint.sh" ]

VOLUME /WeChatFiles