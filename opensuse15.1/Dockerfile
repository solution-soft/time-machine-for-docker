FROM solutionsoft/time-machine-for-centos7:latest AS master

FROM busybox:musl AS toolbox

FROM centos:7 AS reference

FROM opensuse/leap:15.1

LABEL vendor="SolutionSoft Systems, Inc"
LABEL maintainer="kzhao@solution-soft.com"

ENV LICHOST=172.0.0.1 \
    LICPORT=57777 \
    LICPASS=docker

ENV DATADIR=data \
    LOGDIR=log

ENV TZ=America/Los_Angeles

ARG S6_OVERLAY_VERSION=v1.22.1.0

ARG DEFAULT_USER=time-traveler
ARG DEFAULT_HOME=/home/time-traveler

# -- copy 'busybox' from busybox, we need 'tar and gzip'
COPY --from=toolbox /bin/busybox /usr/local/bin/busybox

# -- copy '/usr/share/zoneinfo' from reference, to fix timezone issue.
COPY --from=reference /usr/share/zoneinfo /usr/share/zoneinfo

# -- copy from the master image
COPY --from=master /etc/ssstm /etc/ssstm

# -- updated preloading lib for TM
COPY ./preload /etc/ssstm/

# -- docker image build files
COPY ./build /

ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp

RUN busybox tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
&&  ln -s /usr/local/bin/busybox /sbin/ip \
&&  mkdir -p /tmdata \ 
&&  mkdir -p /run/lock \
&&  useradd -r -m -d ${DEFAULT_HOME} -s /bin/bash -c "Default Time Travel User" ${DEFAULT_USER} \
&&  rm -f /tmp/s6-overlay-amd64.tar.gz

# -- setup preloading
RUN  echo "/etc/ssstm/\$LIB/libssstm.so.1.0" >> /etc/ld.so.preload

# -- expose tmagent listening port
EXPOSE 7800

# -- where TM data stores
VOLUME /tmdata

ENTRYPOINT ["/init"]
