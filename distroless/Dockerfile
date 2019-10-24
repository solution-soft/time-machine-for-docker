FROM solutionsoft/time-machine-for-centos7:latest AS master

FROM busybox:musl AS toolbox

FROM gcr.io/distroless/java:8 AS javaimg

FROM gcr.io/distroless/base

ENV LICHOST=172.0.0.1 \
    LICPORT=57777 \
    LICPASS=docker

ENV DATADIR=data \
    LOGDIR=log

ENV TZ=America/Los_Angeles

ARG S6_OVERLAY_VERSION=v1.22.1.0

# -- copy busybox from the busybox docker image
COPY --from=toolbox /bin/busybox /bin/busybox
COPY --from=toolbox /bin/sh /bin/sh

# -- copy from the build image
COPY --from=master /etc/ssstm /etc/ssstm

# -- updated preloading lib for TM
COPY ./preload /etc/ssstm/

# -- docker image build files
COPY ./build /

ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp

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
     ln -fs busybox sort) \
&&  busybox tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
&&  busybox ln -s /bin/ip /sbin/ip \
&&  mkdir -p /tmdata \ 
&&  rm -f /tmp/s6-overlay-amd64.tar.gz

# distroless base image lacks libz.so, so we will copy from the distroless java image
COPY --from=javaimg /lib/x86_64-linux-gnu/libz.so.1.2.8  /lib/x86_64-linux-gnu/libz.so.1.2.8
RUN  (cd /lib/x86_64-linux-gnu; ln -fs libz.so.1.2.8 libz.so.1)

# -- prepare the preloading lib
RUN echo "/etc/ssstm/lib64/libssstm.so.1.0" >> /etc/ld.so.preload

EXPOSE	7800

# -- TMAgent data will be saved under /tmdata/data and logs are under /tmdata/log
VOLUME	/tmdata

ENTRYPOINT ["/init"]
