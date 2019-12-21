FROM ubuntu:18.04

RUN apt-get update

# Install packages for RAFI development
RUN apt-get install -y \
    git \
    wget \
    cmake \
    emacs \
    libboost-dev \
    libboost-program-options-dev \
    python \
    python3

# Install packages for riscv-tools
RUN apt-get install -y \
    autoconf \
    automake \
    autotools-dev \
    curl \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev \
    libusb-1.0-0-dev \
    gawk \
    build-essential \
    bison \
    flex \
    texinfo \
    gperf \
    libtool \
    patchutils \
    bc \
    zlib1g-dev \
    device-tree-compiler \
    pkg-config \
    libexpat-dev

# Setup envvar and workdir
ENV RISCV /opt/riscv
ENV PATH $PATH:$RISCV/bin
RUN mkdir -p $RISCV

# Setup riscv-gnu-toolchain
WORKDIR $RISCV
RUN git clone https://github.com/riscv/riscv-gnu-toolchain.git

WORKDIR $RISCV/riscv-gnu-toolchain
RUN git submodule update --init --recursive
RUN ./configure --prefix=/opt/riscv
RUN make -j8
RUN make -j8 linux

# Setup riscv-tools
WORKDIR $RISCV
RUN git clone https://github.com/riscv/riscv-tools.git 

WORKDIR $RISCV/riscv-tools
RUN git submodule update --init --recursive
RUN ./build.sh

# Re: Setup envvar
ENV RISCV_TESTS $RISCV/riscv-tools/riscv-tests
