FROM registry.access.redhat.com/rhscl/python-36-rhel7

ENV PYTHON_VERSION=3.6 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off

ENV LICHOST=172.0.0.1 \
    LICPORT=57777 \
    LICPASS=docker

ENV TMAGENT_DATADIR=/tmdata/data \
    TMAGENT_LOGDIR=/tmdata/log

ENV DEFAULT_USER=time-traveler \
    DEFAULT_HOME=/home/time-traveler

ARG TM_VERSION=12.9R3
ARG TINI_VERSION=v0.18.0 

USER root

# - ADD files and install packages

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD ftp://ftp.solution-soft.com/pub/tm/linux/redhat/64bit/tm_linux_2.6.up_x86_64-${TM_VERSION}.tgz /tmp

# - install supervisor and TM

RUN source /opt/rh/rh-python36/enable \
&&  pip3 install supervisor \
&&  (cd /usr/bin; \
     ln -f -s /opt/rh/rh-python36/root/bin/supervisord .; \
     ln -f -s /opt/rh/rh-python36/root/bin/supervisorctl .; \
     ln -f -s /opt/rh/rh-python36/root/bin/echo_supervisord_conf .;) \
&&  mkdir -p /tmp/build \
&&  (cd /tmp/build; \
     tar -xzf /tmp/tm_linux_2.6.up_x86_64-${TM_VERSION}.tgz; \
     ./ssstm_install.sh tm_linux_2.6.up_x86_64-${TM_VERSION}.rpm; \
     yum history sync) \
&&  (cd /etc/ssstm/extras; rm -f .tm*.tgz Makefile.re) \
&&  rm -rf /tmp/* \
&&  adduser -d $DEFAULT_HOME -s /bin/bash -M -r -c "Default User" $DEFAULT_USER \
&&  mkdir -p /tmdata

# - copy tm license daemon

COPY bin/tmlicd /usr/local/bin

# - copy config files

COPY config /

EXPOSE 7800
VOLUME /tmdata

ENTRYPOINT ["/tini", "--", "/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
