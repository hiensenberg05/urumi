#!/usr/bin/env bash
set -e

# Configure Kind container DNS
docker exec -u 0 urumi-local-control-plane bash -c 'cat << "EOF" > /etc/resolv.conf
nameserver 8.8.8.8
nameserver 1.1.1.1
options ndots:0
EOF'

# Restart containerd inside Kind node so it picks up the new resolver
docker exec -u 0 urumi-local-control-plane systemctl restart containerd

echo "Containerd restarted with 8.8.8.8 DNS"
