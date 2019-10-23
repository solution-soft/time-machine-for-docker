FROM solutionsoft/time-machine-for-centos7:latest AS build

FROM opensuse/leap:15.1

LABEL vendor="SolutionSoft Systems, Inc"
LABEL maintainer="kzhao@solution-soft.com"

ENV LICHOST "172.0.0.1"
ENV LICPORT "57777"
ENV LICPASS "docker"

ENV DATADIR "data"
ENV LOGDIR  "log"

ARG S6_OVERLAY_VERSION=v1.22.1.0
ARG TM_LINUX_VERSION=12.9R3

ARG DEFAULT_USER=time-traveler
ARG DEFAULT_HOME=/home/time-traveler

ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp

RUN zypper --non-interactive install tar gzip \
&&  tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
&&  mkdir -p /tmdata \ 
&&  mkdir -p /run/lock \
&&  useradd -r -m -d ${DEFAULT_HOME} -s /bin/bash -c "Default Time Travel User" ${DEFAULT_USER} \
&&  rm -f /tmp/s6-overlay-amd64.tar.gz \
&&  zypper --non-interactive remove -u tar gzip \
&&  zypper --non-interactive clean --all

# -- copy from the build image
COPY --from=build /etc/ssstm /etc/ssstm
COPY --from=build /usr/local/bin/tmlicd /usr/local/bin/tmlicd

# -- updated preloading lib for TM
COPY preload /etc/ssstm/

# -- docker image build files
COPY build /

# -- setup preloading
RUN  echo "/etc/ssstm/\$LIB/libssstm.so.1.0" >> /etc/ld.so.preload

# -- expose tmagent listening port
EXPOSE 7800

# -- where TM data stores
VOLUME /tmdata

ENTRYPOINT ["/init"]
