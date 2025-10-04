#!/bin/bash

set -euo pipefail

cd /bp
source common.sh

#
# $1 scenario (default: scenario1)
#
SCENARIO=${1:-scenario1}

log_info "Starting scenario '${SCENARIO}'..."
setup_scenario ${SCENARIO}

echo ${SCENARIO} > /bp/.scenario

# Spawn interactive shell

cat /bp/BANNER

exec bash -i
