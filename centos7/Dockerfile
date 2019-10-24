FROM busybox:musl AS toolbox

FROM centos:centos7 AS master

ARG TM_LINUX_VERSION=12.9R3

# -- install TM on a fresh centos 7 host

RUN curl -s ftp://ftp.solution-soft.com/pub/tm/linux/redhat/64bit/tm_linux_2.6.up_x86_64-${TM_LINUX_VERSION}.tgz -o /tmp/tm_linux.tgz \
&&  mkdir -p /tmp/build \
&&  tar xzf /tmp/tm_linux.tgz -C /tmp/build \
&&  (cd /tmp/build; ./ssstm_install.sh tm_linux_2.6.up_x86_64-${TM_LINUX_VERSION}.rpm) \
&&  (cd /etc/ssstm/extras; rm -f .tm*.tgz Makefile.re)

FROM centos:centos7

LABEL vendor="SolutionSoft Systems, Inc"
LABEL maintainer="kzhao@solution-soft.com"

ENV LICHOST=172.0.0.1 \
    LICPORT=57777 \
    LICPASS=docker

ENV DATADIR=data \
    LOGDIR=log

ENV TZ=America/Los_Angeles

ARG DEFAULT_USER=time-traveler
ARG DEFAULT_HOME=/home/time-traveler

ARG S6_OVERLAY_VERSION=v1.22.1.0
ARG TMAGENT_VERSION=11.04r65

# -- copy 'busybox' from busybox, we need 'unzip'
COPY --from=toolbox /bin/busybox /usr/local/bin/busybox

# -- copy from the build image
COPY --from=master /etc/ssstm /etc/ssstm

# -- updated preloading lib for TM
COPY ./preload /etc/ssstm/

# -- docker image build files
COPY ./build /

# -- copy update TMAgent release
COPY ./extras/tmagent-linux-x64-${TMAGENT_VERSION}.zip /tmp/tmagent-linux.zip

# -- copy S6 overlay dist file
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp

RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" \
&&  tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin \
&&  (cd /etc/ssstm; busybox unzip -o /tmp/tmagent-linux.zip) \
&&  ln -s /usr/local/bin/busybox /sbin/ip \
&&  mkdir -p /tmdata \
&&  adduser -d ${DEFAULT_HOME} -s /bin/bash -M -r -c "Default Time Travel User" ${DEFAULT_USER} \
&&  rm -rf /tmp/s6-overlay-amd64.tar.gz /tmp/tmagent-linux.zip /tmp/build

# -- setup preloading
RUN  echo "/etc/ssstm/\$LIB/libssstm.so.1.0" >> /etc/ld.so.preload

# -- expose tmagent listening port
EXPOSE 7800

# -- where TM data stores
VOLUME /tmdata

ENTRYPOINT ["/init"]
