FROM fjt7tdmi/rafi-dev

# Install packages for freedom-u-sdk
RUN apt-get install -y \
    cpio \
    unzip \
    rsync \
    libglib2.0-dev \
    libpixman-1-dev \
    linux-firmware

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
ENV RAFI_FREEDOM_U_SDK $RISCV/freedom-u-sdk
