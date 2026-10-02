#!/bin/bash
# Build the image for amd64 and arm64 and push it to Docker Hub
# Usage: ./build.sh [tag]
# The tag defaults to the rsync version pinned in the Dockerfile, e.g. v3.5.0
set -euo pipefail

cd "$(dirname "$0")"

IMAGE="dineiar/rsync-ssh-server"
VERSION="${1:-v$(grep -oE 'rsync=[0-9.]+' Dockerfile | cut -d= -f2)}"

echo "Building and pushing $IMAGE:$VERSION and $IMAGE:latest"
docker buildx build --builder multiarch \
    --platform linux/amd64,linux/arm64 \
    -t "$IMAGE:$VERSION" \
    -t "$IMAGE:latest" \
    --push .
