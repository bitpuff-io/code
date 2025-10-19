#!/bin/bash

set -euo pipefail

cat /bp/BANNER

cat <<'EOF'
Available commands:

  describe               - Describe the scenario (topology, addressing and routing)
  exec <namespace> <cmd> - Execute a single command in the namespace
  help                   - Show this help menu
  shell <namespace>      - Enter a network namespace

=================================================
EOF
