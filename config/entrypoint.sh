#!/bin/bash

DEFAULT_USER=${DEFAULT_USER:-time-traveler}

# make sure the default user is valid
id $DEFAULT_USER> /dev/null 2>/dev/null || DEFAULT_USER=time-traveler

set -e
set -u

# Run startup scripts

if [ -d /inittask ] && [ "$(ls /inittask/*.sh)" ]; then
  for init in /inittask/*.sh; do
    sh $init
  done
  # no need to run it again
  rm -rf /inittask
fi

# If we have an interactive container
if [[ -t 0 || -p /dev/stdin ]]; then
  export PS1='[\u@\h : \w]\$ '
  if [[ $@ ]]; then 
    eval "exec $@"
  else 
    eval /bin/bash
  fi

# If container is detached run superviord in the foreground 
else
  if [[ $@ ]]; then 
    eval "exec $@"
  else
    exec /usr/bin/supervisord -c /etc/supervisord.conf
  fi
fi
