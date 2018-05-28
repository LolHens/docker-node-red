FROM nodered/node-red-docker:latest
LABEL maintainer="LolHens <pierrekisters@gmail.com>"


ENV TINI_VERSION 0.18.0
ENV TINI_URL https://github.com/krallin/tini/releases/download/v$TINI_VERSION/tini

ENV TINI_KILL_PROCESS_GROUP 1

ENV SCALA_VERSION 2.12
ENV AMM_VERSION 1.1.2
ENV AMM_FILE $SCALA_VERSION-$AMM_VERSION
ENV AMM_URL https://github.com/lihaoyi/Ammonite/releases/download/$AMM_VERSION/$AMM_FILE


USER root


ADD ["https://raw.githubusercontent.com/LolHens/docker-tools/master/bin/cleanimage", "/usr/local/bin/"]
RUN chmod +x "/usr/local/bin/cleanimage"

RUN echo "deb http://http.debian.net/debian jessie-backports main" | tee /etc/apt/sources.list.d/jessie-backports.list

RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install -yt jessie-backports \
      sudo \
      nano \
      openjdk-8-jre-headless \
 && cleanimage

RUN curl -L "$AMM_URL" | (echo '#!/usr/bin/env sh' && cat) > /usr/local/bin/amm \
 && chmod +x "/usr/local/bin/amm"

RUN curl -Lo "/usr/local/bin/tini" $TINI_URL \
 && chmod +x "/usr/local/bin/tini"


ENTRYPOINT ["tini", "--"]

VOLUME ["/data"]
EXPOSE 1880

CMD ["npm", "start", "--", "--userDir", "/data"]
