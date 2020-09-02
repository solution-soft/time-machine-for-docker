#!/bin/bash

set -ex

MACHINES="centos7 centos8 rhel7 rhel8 oraclelinux7 oraclelinux8 ubuntu16.04 ubuntu18.04 opensuse15.1 distroless distroless-java8"

TAGNAME="12.10R5-build03"

if [ $# -gt 0 ]; then
    MACHINES=$*
fi

MACHINES=$(echo $MACHINES | xargs -n1 | sort | uniq | xargs)

for n in $MACHINES; do
    if [ -d $n ]; then
	echo "Build TimeMachine docker image for $n .."

	docker build --compress --rm \
	    -t "solutionsoft/time-machine-for-${n}:latest" \
	    -t "solutionsoft/time-machine-for-${n}:${TAGNAME}" \
	    . -f ${n}/Dockerfile
    fi
done

exit 0
