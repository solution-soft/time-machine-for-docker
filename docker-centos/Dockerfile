FROM centos:centos7

ENV LICHOST "172.0.0.1"
ENV LICPORT "57777"
ENV LICPASS "docker"

ENV TMAGENT_DATADIR "/tmdata/data"
ENV TMAGENT_LOGDIR "/tmdata/log"

USER root

COPY release/tm_linux_2.6.up_x86_64-12.9R3.tgz /tmp
COPY py/get-pip.py /tmp

# - install supervisor and TM

RUN mkdir -p /tmdata \
&&  python /tmp/get-pip.py \
&&  pip install --no-cache-dir supervisor \
&&  (cd /tmp; tar -xzf tm_linux_2.6.up_x86_64-12.9R3.tgz; ./ssstm_install.sh tm_linux_2.6.up_x86_64-12.9R3.rpm) \
&&  adduser -r time-traveler \
&&  rm -rf /tmp/*

# - install tmlicd

COPY bin/tmlicd /usr/local/bin

# - install supervisord config files

COPY config /

EXPOSE 7800
VOLUME /tmdata

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
