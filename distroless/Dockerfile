FROM debian:stretch AS toolbox

# gcr:8 is based on debian stretch

RUN set -ex \
&&  apt-get update \
&&  apt-get install busybox


FROM gcr.io/distroless/java:8 AS javaimg

# -- copy busybox from the busybox docker image
COPY --from=toolbox /bin/busybox /bin/busybox
COPY --from=toolbox /bin/sh /bin/sh

# -- packup zlib shared
RUN  (cd /; busybox tar cf /tmp/libz.tar `busybox find lib -name libz.so\*`)


FROM gcr.io/distroless/base:latest

LABEL vendor="SolutionSoft Systems, Inc"
LABEL maintainer="kzhao@solution-soft.com"

ENV LICHOST=172.0.0.1 \
    LICPORT=57777 \
    LICPASS=docker

ENV TMAGENT_PORT=7800

ENV DATADIR=data \
    LOGDIR=log

ENV TZ=America/Los_Angeles

ARG S6_OVERLAY_VERSION=v2.0.0.1
ARG TM_LINUX_VERSION=12.10R5

ADD  https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp

# -- copy TM base img and S6 service scripts
COPY ./tmbase-${TM_LINUX_VERSION}.tgz /tmp/tmbase.tgz
COPY ./build /

# -- copy busybox from the busybox docker image
COPY --from=toolbox /bin/busybox /bin/busybox
COPY --from=toolbox /bin/sh /bin/sh

# distroless base image lacks libz.so, so we will copy from the distroless java image
COPY --from=javaimg /tmp/libz.tar /tmp/libz.tar

# copy timezone info from java image
COPY --from=javaimg /usr/share/zoneinfo /usr/share

RUN (cd /bin; \
     busybox ln -fs busybox ln; \
     ln -fs busybox sh; \
     ln -fs busybox ls; \
     ln -fs busybox ps; \
     ln -fs busybox ip; \
     ln -fs busybox chown; \
     ln -fs busybox chmod; \
     ln -fs busybox cut; \
     ln -fs busybox cat; \
     ln -fs busybox grep; \
     ln -fs busybox rm; \
     ln -fs busybox mkdir; \
     ln -fs busybox wc; \
     ln -fs busybox head; \
     ln -fs busybox sed; \
     ln -fs busybox awk; \
     ln -fs busybox sort) \
&&  busybox tar xf /tmp/libz.tar -C / \
&&  busybox tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
&&  busybox tar xzf /tmp/tmbase.tgz -C / \
&&  rm -f /tmp/libz.tar /tmp/s6-overlay-amd64.tar.gz /tmp/tmbase.tgz \
&&  echo "/etc/ssstm/lib64/libssstm.so.1.0" >> /etc/ld.so.preload \
&&  mkdir -p /tmdata

# -- distroless has a 'nonroot' user account
# no time machine specific user account will be created

# -- where TM data stores
VOLUME /tmdata


ENTRYPOINT ["/init"]
