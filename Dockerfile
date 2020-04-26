FROM zixia/wine:5.0

USER root
RUN apt update && apt install -y \
    pev \
  && apt-get autoremove -y \
  && apt-get clean \
  && chown user /home \
  && rm -fr /tmp/*

USER user

# ARG HOME_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.2.8.0.121.tgz
ARG HOME_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.2.7.1.88.tgz
RUN curl -sL "$HOME_URL" | tar zxf - \
  && echo 'Artifacts Downloaded'

ARG WECHAT_DIR='/home/user/.wine/drive_c/Program Files/Tencent/WeChat'
RUN cd "$WECHAT_DIR" \
  && peres -v WeChatWin.dll | awk '{print $3}' > /home/VERSION.WeChat \
  && echo 'WeChat VERSION generated'

ENV \
  LANG=zh_CN.UTF-8 \
  LC_ALL=zh_CN.UTF-8

VOLUME [\
  "/home/user/WeChat Files", \
  "/home/user/.wine/drive_c/users/user/Application Data" \
]

COPY container_root/ /
COPY [A-Z]* /
COPY VERSION /VERSION.docker-wechat

RUN wine regedit.exe /s /home/wechat-install.reg \
  && wine reg query 'HKEY_CURRENT_USER\Software\Tencent\WeChat' \
  && echo 'Regedit Initialized'

# FIXME: reg set success or not ???
RUN wine reg query 'HKEY_CURRENT_USER\Software\Tencent\WeChat' || echo 'Graceful FAIL. REG NOT FOUND'

# Disable WeChat Upgrade
# https://github.com/huan/docker-wechat/issues/29
ARG PATCH_FILE_DIR=/home/user/.wine/drive_c/users/user/AppData/Roaming/Tencent/WeChat
RUN [ -e "$PATCH_FILE_DIR" ] || mkdir -p "$PATCH_FILE_DIR"; touch "${PATCH_FILE_DIR}"/patch

ENTRYPOINT [ "/entrypoint.sh" ]

LABEL \
    org.opencontainers.image.authors="Huan LI (李卓桓) <zixia@zixia.net>" \
    org.opencontainers.image.description="DoChat(盒装微信) is a Dockerized WeChat(微信) PC Windows Client for Linux." \
    org.opencontainers.image.documentation="https://github.com/huan/docker-wechat/#readme" \
    org.opencontainers.image.licenses="Apache-2.0" \
    org.opencontainers.image.source="git@github.com:huan/docker-wechat.git" \
    org.opencontainers.image.title="DoChat" \
    org.opencontainers.image.url="https://github.com/huan/docker-wechat" \
    org.opencontainers.image.vendor="Huan LI (李卓桓)"
