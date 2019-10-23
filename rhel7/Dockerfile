FROM registry.access.redhat.com/ubi7/ubi

LABEL vendor="SolutionSoft Systems, Inc"
LABEL maintainer="kzhao@solution-soft.com"

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off

ENV LICHOST=172.0.0.1 \
    LICPORT=57777 \
    LICPASS=docker

ENV DATADIR=data \
    LOGDIR=log

ARG DEFAULT_USER=time-traveler
ARG DEFAULT_HOME=/home/time-traveler

ARG S6_OVERLAY_VERSION=v1.22.1.0
ARG TM_LINUX_VERSION=12.9R3

user root

ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp

RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" \
&&  tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin \
&&  curl -s ftp://ftp.solution-soft.com/pub/tm/linux/redhat/64bit/tm_linux_2.6.up_x86_64-${TM_LINUX_VERSION}.tgz -o /tmp/tm_linux.tgz \
&&  mkdir -p /tmp/build \
&&  tar xzf /tmp/tm_linux.tgz -C /tmp/build \
&&  (cd /tmp/build; ./ssstm_install.sh tm_linux_2.6.up_x86_64-${TM_LINUX_VERSION}.rpm) \
&&  (cd /etc/ssstm/extras; rm -f .tm*.tgz Makefile.re) \
&&  mkdir -p /tmdata \
&&  adduser -d ${DEFAULT_HOME} -s /bin/bash -M -r -c "Default Time Travel User" ${DEFAULT_USER} \
&&  rm -rf /tmp/s6-overlay-amd64.tar.gz /tmp/tm_linux.tgz /tmp/build

# -- docker image build files
COPY build /

# -- expose tmagent listening port
EXPOSE 7800

# -- where TM data stores
VOLUME /tmdata

ENTRYPOINT ["/init"]
