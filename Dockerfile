FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive TZ=America/Sao_Paulo
USER root

RUN apt-get update && apt-get install -y \
    build-essential \
    libseccomp-dev \
    pkg-config \
    squashfs-tools \
    squashfuse \
    fuse2fs \
    fuse-overlayfs \
    fakeroot \
    cryptsetup \
    curl wget git \
    vim uidmap \
    bridge-utils \
    iputils-ping \
    libtool \
    libtool-bin \
    dh-autoreconf \
    iptables \
    ebtables \
    iproute2 \
    uidmap

RUN wget https://dl.google.com/go/go1.19.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.19.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

RUN mkdir -p /opt/cni/bin && \
    cd /opt/cni/bin && \
    wget -qO- https://github.com/containernetworking/plugins/releases/download/v1.0.1/cni-plugins-linux-amd64-v1.0.1.tgz | tar xvz

RUN git clone --branch v1.0.3 https://github.com/apptainer/apptainer.git && \
    cd apptainer && \
    chmod +x mconfig && \
    ./mconfig && \
    cd builddir && \
    make && \
    make install

WORKDIR /work
RUN git clone --recurse-submodules https://github.com/TauferLab/ContainerizedEnv && \
    ln -s /apptainer /work/ContainerizedEnv/plugin/singularity_source

ENV PATH="/usr/local/bin:$PATH"

RUN apptainer --version

CMD ["apptainer", "--version"]
