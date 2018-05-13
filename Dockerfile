FROM nodered/node-red-docker:latest
LABEL maintainer="LolHens <pierrekisters@gmail.com>"


ENV TINI_VERSION 0.18.0
ENV TINI_URL https://github.com/krallin/tini/releases/download/v$TINI_VERSION/tini


ADD ["https://raw.githubusercontent.com/LolHens/docker-tools/master/bin/cleanimage", "/usr/local/bin/"]
RUN ls -la "/usr/local/bin/"
RUN chmod +x "/usr/local/bin/cleanimage"

RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install -y \
      sudo \
      nano \
 && cleanimage

RUN curl -Lo "/usr/local/bin/tini" $TINI_URL \
 && chmod +x "/usr/local/bin/tini"


ENTRYPOINT ["tini", "-g", "--"]
