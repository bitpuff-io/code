SUDO=$([ "$(id -u)" -eq 0 ] || echo sudo)

if [ "${VERBOSE:-0}" == "1" ]; then
    set -x
fi

_log(){
	echo "[${1}] ${2}"
}

log_info(){
	_log "INFO" "${1}"
}

log_warn(){
	_log "WARN" "${1}"
}

log_err(){
	_log "ERROR" "${1}"
}

log_debug(){
	_log "DBG" "${1}"
}

setup_etc_hosts(){
	cp -f /bp/hosts /etc/hosts
}

# $1 namespace name
_check_ns(){
	if ! ${SUDO} ip netns exec ${1} true >/dev/null 2>&1 ; then
		log_err "Invalid namespace: '${1}'"
		return 1
	fi
}

# $1 namespace
# $2 iface
_check_ns_iface(){
	if ! ${SUDO} ip netns exec ${1} ip link show dev ${2} >/dev/null 2>&1 ; then
		log_err "Invalid iface: '${2}' in namespace '${1}'!"
		return 1
	fi

}

# Parses namespace and interface
# and sets them to CMD_NS and CMD_IFACE
# $1 namespace.interface
_parse_ns_iface(){
	CMD_NS="$(echo ${1} | awk -F. '{print $1}')"
	CMD_IFACE="$(echo ${1} | awk -F. '{print $2}')"
	echo "Checking ${CMD_NS} and ${CMD_IFACE}"
	_check_ns ${CMD_NS}
	_check_ns_iface ${CMD_NS} ${CMD_IFACE}
}

# $1 namespace name
create_ns() {
	${SUDO} ip netns add ${1}
	${SUDO} ip netns exec ${1} ip link set up dev lo
}

# $1 namespace name
destroy_ns() {
	${SUDO} ip netns del ${1}
}

# $1 ns1
# $2 iface1 name
# $3 ns2
# $4 iface2 name
create_link() {
	${SUDO} ip netns exec ${1} ip link add ${2} type veth peer name _tmp
	${SUDO} ip netns exec ${1} ip link set up dev ${2}
	${SUDO} ip netns exec ${1} ip link set netns ${3} dev _tmp
	${SUDO} ip netns exec ${3} ip link set _tmp name ${4}
	${SUDO} ip netns exec ${3} ip link set up dev ${4}
}

# $1 ns1
# $2 iface1 name
destroy_link() {
	${SUDO} ip netns exec ${1} ip link del ${2}
}

# $1 ns
# $2 dev
# $3 addr
add_addr(){
	${SUDO} ip netns exec ${1} ip addr add ${3} dev ${2}
}

# $1 ns
# $2 route
add_route(){
	${SUDO} ip netns exec ${1} ip route add ${2}
}

# $1 ns
# $2 dev
# $3 mtu
set_iface_mtu(){
	${SUDO} ip netns exec ${1} ip link set dev ${2} mtu ${3}
}

# $1 ns
# $2 ip_forward value (0, 1)
set_sysctl_ip_forward(){
	${SUDO} ip netns exec ${1} sysctl -q -w net.ipv4.ip_forward=${2}
}

list_scenarios(){
	find . -maxdepth 1 -type d ! -name '.*' -printf '%P\n'
}

# $1 scenario name
setup_scenario() {
	if [ ! -d "${1}" ]; then
		log_err "Invalid scenario ${1}"
		echo "Valid scenarios are '$(list_scenarios)'"
		exit 1
	fi

	cd ${1} && ./setup.sh
	echo ${1} > /bp/.scenario
}
