#!/usr/bin/env bash
set -e
docker exec urumi-local-control-plane bash -c 'echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf'
docker exec urumi-local-control-plane getent hosts registry.k8s.io
echo "DNS fixed and registry.k8s.io resolved successfully!"
