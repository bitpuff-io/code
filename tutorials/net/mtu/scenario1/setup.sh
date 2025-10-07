#!/bin/bash

set -e

source ../common.sh

# Create the topology
create_ns host1
create_ns routerx
create_ns routery
create_ns host2

create_link host1 eth0 routerx ens1
create_link routerx ens2 routery ens1
create_link routery ens2 host2 eth0

add_addr host1 eth0 192.168.0.2/24
add_route host1 "default via 192.168.0.1"

add_addr routerx ens1 192.168.0.1/24
add_addr routerx ens2 192.168.1.1/24
add_route routerx "192.168.2.0/24 via 192.168.1.2"

add_addr routery ens1 192.168.1.2/24
add_addr routery ens2 192.168.2.1/24
add_route routery "192.168.0.0/24 via 192.168.1.1"

add_addr host2 eth0 192.168.2.2/24
add_route host2 "default via 192.168.2.1"

# routerx.ens2-routery.ens1 has a constrained MTU of 1400 (matching MTUs)
set_iface_mtu routerx ens2 1400
set_iface_mtu routery ens1 1400

set_sysctl_ip_forward routerx 1
set_sysctl_ip_forward routery 1
