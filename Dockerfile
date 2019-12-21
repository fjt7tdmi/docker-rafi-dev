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
    python

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

# Install packages for freedom-u-sdk
RUN apt-get install -y \
    cpio \
    unzip \
    rsync \
    libglib2.0-dev \
    libpixman-1-dev \
    linux-firmware

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

# Setup freedom-u-sdk
WORKDIR $RISCV
RUN git clone https://github.com/sifive/freedom-u-sdk.git -b hifiveu-2.0-alpha

WORKDIR $RISCV/freedom-u-sdk
RUN git submodule update --init --recursive
RUN sed -i -e 's/riscv64-buildroot-linux-gnu/riscv64-unknown-linux-gnu/' /opt/riscv/freedom-u-sdk/Makefile
RUN make -j8 bbl
RUN make -j8 vmlinux
RUN make -j8 initrd

# Re: Setup envvar
ENV RISCV_TESTS $RISCV/riscv-tools/riscv-tests
ENV RAFI_FREEDOM_U_SDK $RISCV/freedom-u-sdk
