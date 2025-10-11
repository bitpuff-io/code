#!/bin/bash

set -euo pipefail

source /bp/common.sh

# multi-exec on multiple namespaces
# $1 namespace1
# $2 command1
# $3 namespace2
# $4 command2
# $5 [optional, split: vertical or horizontal ]

if [ $# -lt 4 ] || [ $# -gt 5 ]; then
	log_err "Invalid number of parameters"
	log_err "Usage: ${0} ns1 cmd1 ns2 cmd2 [horizontal | vertical]"
	exit 1
fi

MODE="${5:-horizontal}"

#_check_ns ${1}
NS1=${1}
CMD1=${2}

#_check_ns ${3}
NS2=${3}
CMD2=${4}

# Disable welcome messages for clean view
export BYOBU_NO_WELCOME=1
export BYOBU_DISABLE_STATUS=1
#export BYOBU_BACKEND=tmux

if [ "${MODE}" != "vertical" ]; then
	SPLIT_OP="-h"
	LAYOUT="even-horizontal"
else
	SPLIT_OP="-v"
	LAYOUT="even-vertical"
fi


SESSION="duoexec$$"

LABEL1="${CMD1}"
LABEL2="${CMD2}"
CMD1="${SUDO} ip netns exec ${NS1} bash -c \"${CMD1}\""
CMD2="${SUDO} ip netns exec ${NS2} bash -c \"${CMD2}\""

byobu new-session -A -d -s "${SESSION}" "echo ${CMD1}; ${CMD1}"
byobu split-window ${SPLIT_OP} -t "${SESSION}" "echo ${CMD2}; ${CMD2}"

byobu select-layout -t "${SESSION}" ${LAYOUT}
byobu rename-window -t "${SESSION}" "${NS1}$ ${LABEL1} | ${NS2}$ ${LABEL2}"
byobu attach-session -t "${SESSION}"
