#!/bin/bash

set -euo pipefail

source /bp/common.sh

if [ ! -f /bp/.scenario ]; then
    log_err "Unknown or invalid scenario"
fi
SCENARIO=$(< /bp/.scenario)

echo "================================================="
echo "        🐧  Scenario: '${SCENARIO}'  🐧          "
echo "================================================="
echo""

cat /bp/${SCENARIO}/TOPOLOGY.md
echo""
for ns in $(ip netns list | awk '{print $1}'); do
	echo "================================================="
	echo -e "\033[1;34mNamespace: $ns\033[0m"
	echo "-------------------------------------------------"
	echo "IP addressing:"
	ip netns exec ${ns} ip -brief addr
	echo ""
	echo "Routing table:"
	ip netns exec ${ns} ip -brief route
	echo -e "\n"
done
