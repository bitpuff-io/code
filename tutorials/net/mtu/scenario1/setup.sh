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

addr_add host1 eth0 192.168.0.2/24
route_add host1 "default via 192.168.0.1"

addr_add routerx ens1 192.168.0.1/24
addr_add routerx ens2 192.168.1.1/24
route_add routerx "192.168.2.0/24 via 192.168.1.2"

addr_add routery ens1 192.168.1.2/24
addr_add routery ens2 192.168.2.1/24
route_add routery "192.168.0.0/24 via 192.168.1.1"

addr_add host2 eth0 192.168.2.2/24
route_add host2 "default via 192.168.2.1"
