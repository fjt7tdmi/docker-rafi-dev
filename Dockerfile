FROM ubuntu:18.04

RUN apt-get update

# Install packages for rafi-emu
RUN apt-get install -y \
    build-essential \
    cmake \
    git \
    libboost-dev \
    libboost-program-options-dev \
    python
