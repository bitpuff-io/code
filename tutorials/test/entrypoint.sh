#!/bin/bash

set -euo pipefail

cat /bp/BANNER

echo "[INFO] Creating namespace 'bp_test_ns'..."
ip netns add bp_test_ns

echo "[INFO] Executing command inside the NS..."
ip netns exec bp_test_ns echo "Hello world!"

echo "[INFO] All is good!"
