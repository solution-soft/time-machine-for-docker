#!/bin/bash

set -ex

echo "Build TimeMachine docker image for CentOS 7 .."
NAME="time-machine-for-centos7"
docker build --rm --pull --compress \
  -t solutionsoft/${NAME}:latest \
  . -f centos7/Dockerfile

docker push "solutionsoft/${NAME}:latest"

echo "Build TimeMachine docker image for CentOS 8 .."
NAME="time-machine-for-centos8"
docker build --rm --pull --compress \
  -t solutionsoft/$NAME:latest \
  . -f centos8/Dockerfile

docker push "solutionsoft/${NAME}:latest"

echo "Build TimeMachine docker image for RHEL 7 .."
NAME="time-machine-for-rhel7"
docker build --rm --pull --compress \
  -t solutionsoft/$NAME:latest \
  . -f rhel7/Dockerfile

docker push "solutionsoft/${NAME}:latest"

echo "Build TimeMachine docker image for RHEL 8 .."
NAME="time-machine-for-rhel8"
docker build --rm --pull --compress \
  -t solutionsoft/$NAME:latest \
  . -f rhel8/Dockerfile

docker push "solutionsoft/${NAME}:latest"

echo "Build TimeMachine docker image for OracleLinux 7 .."
NAME="time-machine-for-oraclelinux7"
docker build --rm --pull --compress \
  -t solutionsoft/$NAME:latest \
  . -f oel7/Dockerfile

docker push "solutionsoft/${NAME}:latest"

echo "Build TimeMachine docker image for OracleLinux 8 .."
NAME="time-machine-for-oraclelinux8"
docker build --rm --pull --compress \
  -t solutionsoft/$NAME:latest \
  . -f oel8/Dockerfile

docker push "solutionsoft/${NAME}:latest"

echo "Build TimeMachine docker image for Ubuntu Bionic 18.04 .."
NAME="time-machine-for-ubuntu18.04"
docker build --rm --pull --compress \
  -t solutionsoft/$NAME:latest \
  . -f ubuntu18.04/Dockerfile

docker push "solutionsoft/${NAME}:latest"

echo "Build TimeMachine docker image for OpenSuse Leap 15.1 .."
NAME="time-machine-for-opensuse15.1"
docker build --rm --pull --compress \
  -t solutionsoft/$NAME:latest \
  . -f opensuse15.1/Dockerfile

docker push "solutionsoft/${NAME}:latest"

echo "Build TimeMachine docker image for distroless .."
NAME="time-machine-for-distroless"
docker build --rm --pull --compress \
  -t solutionsoft/$NAME:latest \
  . -f distroless/Dockerfile

docker push "solutionsoft/${NAME}:latest"

exit 0
