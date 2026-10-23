#!/usr/bin/env bash
# =================================================================
# Urumi MCP Gateway - Docker Hub Image Tagging & Push Script
# Usage: ./scripts/push_images.sh <DOCKERHUB_USERNAME>
# =================================================================

set -e

REGISTRY="${1:-hiensenbergg}"

if [ -z "$1" ]; then
    echo "Usage: ./scripts/push_images.sh <dockerhub_username>"
    echo "Defaulting to registry tag: $REGISTRY"
fi

echo "================================================================="
echo " Tagging and Pushing Urumi Platform Container Images"
echo " Registry Target: $REGISTRY"
echo "================================================================="

IMAGES=(
    "urumi/mcp-gateway:v1.6.7|mcp-gateway|v1.6.7"
    "urumi/ai-service:v1.3.6|ai-service|v1.3.6"
    "urumi/frontend:v1.0.0|frontend|v1.0.0"
    "urumi/woocommerce-mcp:v1.1.0|woocommerce-mcp|v1.1.0"
    "urumi/inventory-mcp:v1.1.1|inventory-mcp|v1.1.1"
    "urumi/analytics-mcp:v1.1.0|analytics-mcp|v1.1.0"
    "urumi/hosted-mcp:latest|hosted-mcp|latest"
)

for entry in "${IMAGES[@]}"; do
    IFS="|" read -r local_img target_repo tag <<< "$entry"
    remote_tag="$REGISTRY/$target_repo:$tag"
    remote_latest="$REGISTRY/$target_repo:latest"

    echo "Tagging: $local_img -> $remote_tag"
    docker tag "$local_img" "$remote_tag"
    docker tag "$local_img" "$remote_latest"

    echo "Pushing: $remote_tag"
    docker push "$remote_tag" || echo "Warning: Push failed. Make sure you are logged in via 'docker login'."
    docker push "$remote_latest" || true
done

echo "================================================================="
echo " Image Push Sequence Completed!"
echo "================================================================="
