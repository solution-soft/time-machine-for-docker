#!/bin/bash

set -e
set -u

# Run startup scripts

if [ "$(ls /inittask/)" ]; then
  for init in /inittask/*.sh; do
    . $init
  done
  # no need to run it again
  rm -f /inittask/*.sh
fi

# If we have an interactive container
if test -t 0; then
  # Execute commands passed to container and exit, or run bash
  if [[ $@ ]]; then 
    eval $@
  else 
    export PS1='[\u@\h : \w]\$ '
    /bin/bash
  fi

# If container is detached run superviord in the foreground 
else
  if [[ $@ ]]; then 
    eval "exec $@"
  else 
    exec /usr/bin/supervisord -c /etc/supervisord.conf
  fi
fi
