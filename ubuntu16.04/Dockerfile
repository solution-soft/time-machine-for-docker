FROM ubuntu:16.04

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

ARG S6_OVERLAY_VERSION=v2.0.0.1
ARG TM_LINUX_VERSION=12.10R5

# For installing software packages
USER root

# -- copy S6 overlay dist file
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp

COPY ./tmbase-${TM_LINUX_VERSION}.tgz /tmp/tmbase.tgz
COPY ./build /

RUN set -ex \
&&  apt-get update \
&&  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends iproute2 tzdata \
&&  apt-get clean \
&&  rm -rf /var/lib/apt/lists/* \
&&  tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
&&  rm -f /tmp/s6-overlay-amd64.tar.gz \
&&  tar xzf /tmp/tmbase.tgz -C / \
&&  rm -f /tmp/tmbase.tgz \
&&  echo "/etc/ssstm/lib64/libssstm.so.1.0" >> /etc/ld.so.preload \
&&  mkdir -p /tmdata \
&&  useradd -r -m -d ${DEFAULT_HOME} -s /bin/bash -c "Default Time Travel User" ${DEFAULT_USER}

# -- expose tmagent listening port
EXPOSE 7800

# -- where TM data stores
VOLUME /tmdata

ENTRYPOINT ["/init"]
