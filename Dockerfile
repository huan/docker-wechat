FROM zixia/wine:5.0.0

RUN apt update && apt install -y \
    pev \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -fr /tmp/*

ARG HOME_URL=https://github.com/huan/docker-wechat/releases/download/v0.1/home.2.8.0.112.tgz
RUN curl -sL "$HOME_URL" | tar zxf - \
  && chown -R user:group /home/user \
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

RUN su user -c "wine regedit.exe /s /home/install.reg" \
  && su user -c "wine reg query 'HKEY_CURRENT_USER\Software\Tencent\WeChat'" \
  && echo 'Regedit initialized'
# FIXME: reg set success or not ???
RUN su user -c "wine reg query 'HKEY_CURRENT_USER\Software\Tencent\WeChat'" || echo 'Graceful FAIL. REG NOT FOUND'

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
