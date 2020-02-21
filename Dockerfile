FROM ubuntu:eoan

ARG DEBIAN_FRONTEND=noninteractive

ENV \
  LANG='C.UTF-8' \
  LC_ALL='C.UTF-8' \
  TZ=Asia/Shanghai \
  WINEDEBUG=-all

RUN dpkg --add-architecture i386 \
  && echo 'i386 Architecture Added'

RUN apt-get update \
  && apt-get install -y \
    wine32:i386 \
    \
    # https://github.com/wszqkzqk/deepin-wine-ubuntu/issues/188#issuecomment-554599956
    # https://zj-linux-guide.readthedocs.io/zh_CN/latest/tool-install-configure/%5BUbuntu%5D%E4%B8%AD%E6%96%87%E4%B9%B1%E7%A0%81/
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
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -fr /tmp/*

RUN groupadd group \
  && useradd -m -g group user \
  && usermod -a -G audio user \
  && usermod -a -G video user \
  && chsh -s /bin/bash user \
  && echo 'User created'

ARG GECKO_VER=2.47
ARG MONO_VER=4.9.4

RUN mkdir -p /usr/share/wine/{gecko,mono} \
  && curl -sL -o /usr/share/wine/gecko/wine_gecko-${GECKO_VER}-x86.msi \
    "https://dl.winehq.org/wine/wine-gecko/${GECKO_VER}/wine_gecko-${GECKO_VER}-x86.msi" \
  # && curl -sL -o /usr/share/wine/mono/wine-mono-${MONO_VER}.msi \
  #   "https://dl.winehq.org/wine/wine-mono/${MONO_VER}/wine-mono-${MONO_VER}.msi" \
  && chown -R user:group /usr/share/wine/gecko /usr/share/wine/mono \
  && echo 'Gecko & Mono installed' \
  \
  && curl -sL -o /usr/local/bin/winetricks \
    https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
  && chmod +x /usr/local/bin/winetricks \
  && echo 'winetricks installed' \
  \
  && su user -c 'WINEARCH=win32 wine wineboot' \
  \
  # wintricks
  && su user -c 'winetricks -q win7' \
  && su user -c 'winetricks -q riched20' \
  \
  # Clean
  && rm -fr /usr/share/wine/{gecko,mono} \
  && rm -fr /home/user/{.cache,tmp}/* \
  && rm -fr /tmp/* \
  && echo 'Wine: initialized'

ARG HOME_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.tgz
RUN curl -sL "$HOME_URL" | tar zxf - \
  && chown -R user:group /home/user \
  && echo 'Artifacts: downlaoded'

RUN su user -c "wine regedit.exe /s 'C:\Program Files\Tencent\WeChat\install.reg'" \
  && su user -c "wine reg query 'HKEY_CURRENT_USER\Software\Tencent\WeChat'" \
  && echo 'Regedit initialized'

# FIXME: reg set success or not ???
RUN su user -c "wine reg query 'HKEY_CURRENT_USER\Software\Tencent\WeChat'" || echo 'Graceful FAIL. REG NOT FOUND'

ENV \
  LANG=zh_CN.UTF-8 \
  LC_ALL=zh_CN.UTF-8

VOLUME [\
  "/home/user/WeChat Files", \
  "/home/user/.wine/drive_c/users/user/Application Data" \
]

COPY [A-Z]* /
COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]

LABEL \
    org.opencontainers.image.authors="Huan (李卓桓) <zixia@zixia.net>" \
    org.opencontainers.image.description="DoChat(盒装微信) is a Dockerized WeChat(微信) PC Windows Client for Linux." \
    org.opencontainers.image.documentation="https://github.com/huan/docker-wechat/#readme" \
    org.opencontainers.image.licenses="Apache-2.0" \
    org.opencontainers.image.source="git@github.com:huan/docker-wechat.git" \
    org.opencontainers.image.title="DoChat" \
    org.opencontainers.image.url="https://github.com/huan/docker-wechat" \
    org.opencontainers.image.vendor="Huan LI (李卓桓)"
