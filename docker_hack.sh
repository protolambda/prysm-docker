#!/bin/bash

# Create build environment
docker build -t prysmbuilder -f builder.Dockerfile .

# Run builder container, wait for completion.
# It mounts:
# - the docker socket to insert the produced images into the host docker environment
# - the prysm dir, to cache the build, and don't have to copy all files over into the image for building.
PRYSM_DIR=$(readlink -f ../prysm)
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PRYSM_DIR:/prysmbuilder" -v "${PWD}/docker_build.sh:/docker_build.sh" -w /prysmbuilder prysmbuilder /docker_build.sh
