#!/bin/sh
set -e

# Create TM Floating license file based on the environment
TM_LICHOST=${TM_LICHOST:-127.0.0.1}
TM_LICPORT=${TM_LICPORT:-57777}
TM_LICPASS=${TM_LICPASS:-docker}

mkdir -p /opt/solutionsoft/timemachine
echo "$TM_LICHOST:$TM_LICPORT:$TM_LICPASS" > /opt/solutionsoft/timemachine/licserverhost
