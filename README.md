# Prysm docker

To run bazel and build Prysm docker images, in a stable build environment.

Motivation:
- Bazel 3.7 usage. Can't install latest bazel that fixes issues like the LLVM download path (see below)
- LLVM Bazel issue: bazel WORKSPACE was broken on new machines until recently
- Bazel docker-rules fetches data from github CDN, but does it wrong, and requires a patch until newer version
- GLIBC issue: host with GLIBC 2.32+ can't build working docker image due to pthreads GLIBC change, not working since distroless base image is GLIBC 2.24, and latest distroless is stuck at 2.28.

This runs all the bazel builds in a docker container, to produce mainnet and minimal variants, and pushes them into the host docker env.

