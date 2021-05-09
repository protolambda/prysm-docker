#!/bin/bash

BEACON_TAG=protolambda/prysm-beacon:rayonism
VALIDATOR_TAG=protolambda/prysm-validator:rayonism

bazelisk run //beacon-chain:image_bundle
bazelisk run //validator:image_bundle

# retag the images to specific names
docker tag gcr.io/prysmaticlabs/prysm/beacon-chain:latest "$BEACON_TAG"
docker tag gcr.io/prysmaticlabs/prysm/validator:latest "$VALIDATOR_TAG"

bazelisk run //beacon-chain:image_bundle --define=ssz=minimal
bazelisk run //validator:image_bundle --define=ssz=minimal

# retag the images to specific names
docker tag gcr.io/prysmaticlabs/prysm/beacon-chain:latest "$BEACON_TAG-minimal"
docker tag gcr.io/prysmaticlabs/prysm/validator:latest "$VALIDATOR_TAG-minimal"
