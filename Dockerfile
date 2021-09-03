FROM zixia/wine:6.0

USER root
RUN apt update && apt install -y \
    locales \
    mesa-utils \
    procps \
    pev \
    sudo \
    vim \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -fr /tmp/*

ENV \
  LANG=zh_CN.UTF-8 \
  LC_ALL=zh_CN.UTF-8

COPY --chown=user:group container_root/ /
COPY [A-Z]* /
COPY VERSION /VERSION.docker-wechat

RUN chown user /home \
  && localedef -i zh_CN -c -f UTF-8 zh_CN.UTF-8 \
  && echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && echo '127.0.0.1 dldir1.qq.com' >> /etc/hosts

USER user
RUN bash -x /setup.sh
ENTRYPOINT [ "/entrypoint.sh" ]

#
# Huan(202004): VOLUME should be put to the END of the Dockerfile
#   because it will frezz the contents in the volume directory
#   which means the content in the directory will lost all changes after the VOLUME command
#
RUN mkdir -p "/home/user/WeChat Files" "/home/user/.wine/drive_c/users/user/Application Data" \
  && chown user:group "/home/user/WeChat Files" "/home/user/.wine/drive_c/users/user/Application Data"
VOLUME [\
  "/home/user/WeChat Files", \
  "/home/user/.wine/drive_c/users/user/Application Data" \
]

LABEL \
    org.opencontainers.image.authors="Huan LI (李卓桓) <zixia@zixia.net>" \
    org.opencontainers.image.description="DoChat(盒装微信) is a Dockerized WeChat(微信) PC Windows Client for Linux." \
    org.opencontainers.image.documentation="https://github.com/huan/docker-wechat/#readme" \
    org.opencontainers.image.licenses="Apache-2.0" \
    org.opencontainers.image.source="git@github.com:huan/docker-wechat.git" \
    org.opencontainers.image.title="DoChat" \
    org.opencontainers.image.url="https://github.com/huan/docker-wechat" \
    org.opencontainers.image.vendor="Huan LI (李卓桓)"
