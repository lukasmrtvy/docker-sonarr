FROM alpine:3.7

ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm' 

ENV SONARR_VERSION='2.0.0.5085'

ENV UID 1000
ENV GID 1000
ENV USER htpc
ENV GROUP htpc

ENV XDG_CONFIG_HOME /config/

# https://github.com/Sonarr/Sonarr/issues/1928
# https://bugzilla.xamarin.com/show_bug.cgi?id=58015
ENV MONO_TLS_PROVIDER=legacy

RUN addgroup -S ${GROUP} -g ${GID} && adduser -D -S -u ${UID} ${USER} ${GROUP}  && \
  echo @testing http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
  apk -U upgrade && \
  apk -U add --no-cache \
    libmediainfo \
    mono@testing \
    curl && \
  mkdir -p /config/ /opt/sonarr && curl -sSL http://download.sonarr.tv/v2/master/mono/NzbDrone.master.${SONARR_VERSION}.mono.tar.gz | tar xz -C /opt/sonarr --strip-components=1 && \
  chown -R ${USER}:${GROUP} /config/ /opt/sonarr/ && \
  apk del curl tar

EXPOSE 8989 9898 

VOLUME /config/

USER ${USER}

ENTRYPOINT ["mono", "/opt/sonarr/NzbDrone.exe", "--no-browser -data=/config"]
