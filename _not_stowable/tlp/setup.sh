#!/usr/bin/env bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
sudo cp "$SCRIPT_DIR/etc/tlp.d/99-custom.conf" /etc/tlp.d/
sudo tlp start
echo "TLP config deployed and started"
