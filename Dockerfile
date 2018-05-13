FROM nodered/node-red-docker:latest
LABEL maintainer="LolHens <pierrekisters@gmail.com>"


ENV TINI_VERSION 0.18.0
ENV TINI_URL https://github.com/krallin/tini/releases/download/v$TINI_VERSION/tini


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

RUN ( \
      echo "#!/usr/bin/env sh" \
   && curl -L https://github.com/lihaoyi/Ammonite/releases/download/1.1.0/2.12-1.1.0-17-6c3552c \
    ) > /usr/local/bin/amm \
 && chmod +x "/usr/local/bin/amm"

RUN curl -Lo "/usr/local/bin/tini" $TINI_URL \
 && chmod +x "/usr/local/bin/tini"

RUN echo "node-red:node-red" | chpasswd \
 && adduser "node-red" sudo


USER node-red


ENTRYPOINT ["tini", "-g", "--"]


VOLUME ["/data"]
EXPOSE 1880

CMD ["npm", "start", "--", "--userDir", "/data"]
