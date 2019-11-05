FROM solutionsoft/time-machine-for-centos7:latest AS master

FROM ubuntu:18.04

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

# -- copy from the master image
COPY --from=master /etc/ssstm /etc/ssstm

# -- updated preloading lib for TM
COPY ./preload /etc/ssstm/

# -- docker image build files
COPY ./build /

# -- add S6-overlay package
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp

RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
&&  apt-get update \
&&  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    tzdata iproute2 \
&&  mkdir -p /tmdata \
&&  useradd -r -m -d ${DEFAULT_HOME} -s /bin/bash -c "Default Time Travel User" ${DEFAULT_USER} \
&&  rm -f /tmp/s6-overlay-amd64.tar.gz \
&&  rm -rf /var/lib/apt/lists/* \

# -- setup preloading
RUN  echo "/etc/ssstm/lib64/libssstm.so.1.0" >> /etc/ld.so.preload

# -- expose tmagent listening port
EXPOSE 7800

# -- where TM data stores
VOLUME /tmdata

ENTRYPOINT ["/init"]
