FROM centos:8 as build

# Based on Docker file from: https://github.com/prysmaticlabs/prysm/issues/5134

ENV TERM=linux
ENV LANG=en_US.UTF-8

RUN dnf install -y 'dnf-command(config-manager)' && \
    dnf install -y gmp-c++ gmp-devel unzip python36 git gcc patch gcc-c++ go ncurses-compat-libs

# Install bazelisk as bazel. Bazelisk downloads the appropriate version of bazel as required by Prysm.
RUN export PATH=$PATH:$(go env GOPATH)/bin
RUN go get github.com/bazelbuild/bazelisk
RUN ln -s $(go env GOPATH)/bin/bazelisk /usr/bin/bazel

# Copy in prysm
COPY prysm prysm
WORKDIR prysm

# Build beacon-chain with llvm and release configuration.
RUN ./bazel.sh build --config=release --config=llvm //beacon-chain:beacon-chain

# Copy binary to new image
# TODO: if prysm can build static, then scratch image can be used.
FROM centos:8

COPY --from=build /prysm/bazel-out/k8-opt/bin/beacon-chain/linux_amd64_stripped/beacon-chain /usr/bin/beacon-chain

VOLUME /data

WORKDIR /data

EXPOSE 4000/tcp
EXPOSE 13000/tcp
EXPOSE 4001/tcp
EXPOSE 8080/tcp

ENTRYPOINT [ "/usr/bin/beacon-chain" ]

USER 1001
