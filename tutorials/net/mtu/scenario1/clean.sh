#!/bin/bash

set +e

source ../common.sh

destroy_link host1 eth0
destroy_link routerx ens2
destroy_link routery ens2

destroy_ns host1
destroy_ns routerx
destroy_ns routery
destroy_ns host2
