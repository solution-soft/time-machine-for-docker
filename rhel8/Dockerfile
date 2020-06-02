FROM registry.access.redhat.com/ubi8/ubi

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
ARG TM_LINUX_VERSION=12.10R4

user root

# -- copy S6 overlay dist file
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp

COPY ./tmbase-${TM_LINUX_VERSION}.tgz /tmp/tmbase.tgz
COPY ./build /

RUN yum -y install iproute && yum clean all \
&&  tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude='./bin' && tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin \
&&  rm -f /tmp/s6-overlay-amd64.tar.gz \
&&  tar xzf /tmp/tmbase.tgz -C / \
&&  rm -f /tmp/tmbase.tgz \
&&  echo "/etc/ssstm/\$LIB/libssstm.so.1.0" >> /etc/ld.so.preload \
&&  mkdir -p /tmdata \
&&  adduser -d ${DEFAULT_HOME} -s /bin/bash -M -r -c "Default Time Travel User" ${DEFAULT_USER}

# -- expose tmagent listening port
EXPOSE 7800

# -- where TM data stores
VOLUME /tmdata

ENTRYPOINT ["/init"]
