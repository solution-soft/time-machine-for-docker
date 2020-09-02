#!/usr/bin/with-contenv sh

set -e

TMAGENT_PORT=${TMAGENT_PORT:-7800}

cat > /etc/ssstm/tmagent/TMAgent.ini <<EOF
# TimeMachine agent web service configuration

[TMAgent]
port = ${TMAGENT_PORT}
EOF



DATADIR=${DATADIR:-data}
LOGDIR=${LOGDIR:-log}

TMAGENT_DATADIR="/tmdata/${DATADIR}"
TMAGENT_LOGDIR="/tmdata/${LOGDIR}"

# Fix permissions for the running environment
[ -d $TMAGENT_DATADIR ] || (mkdir -p $TMAGENT_DATADIR && chown -R root:root $TMAGENT_DATADIR)
[ -d $TMAGENT_LOGDIR ]  || (mkdir -p $TMAGENT_LOGDIR && chown -R root:root $TMAGENT_LOGDIR)

exit 0
