FROM lsiobase/ubuntu:jammy as base

COPY docker/root/ /

ENV DEBIAN_FRONTEND=noninteractive
ENV WEBUI_VERSION=01
ENV BASE_DIR=/config/stable-diffusion
ENV SD_INSTALL_DIR=/opt/sd-install
ENV SD01_DIR=/config/stable-diffusion/01-easy-diffusion
ENV SD02_DIR=/config/stable-diffusion/02-sd-webui
ENV SD03_DIR=/config/stable-diffusion/03-invokeai
ENV SD04_DIR=/config/stable-diffusion/04-SD-Next
ENV SD05_DIR=/config/stable-diffusion/05-comfy-ui
ENV SD06_DIR=/config/stable-diffusion/06-Fooocus
ENV SD07_DIR=/config/stable-diffusion/07-StableSwarm
ENV SD08_DIR=/config/stable-diffusion/08-voltaML
ENV SD20_DIR=/config/stable-diffusion/20-kubin
ENV SD50_DIR=/config/stable-diffusion/50-lama-cleaner
ENV SD51_DIR=/config/stable-diffusion/51-facefusion
ENV SD70_DIR=/config/stable-diffusion/70-kohya
ENV XDG_CACHE_HOME=/config/stable-diffusion/temp

RUN apt-get update -y -q=2 && \
    apt-get install -y -q=2 curl \
    wget \
    mc \
    nano \
    rsync \
    libgl1-mesa-glx \
    libtcmalloc-minimal4 \
    libcufft10 \
    cmake \
    build-essential \
    python3-opencv \
    libopencv-dev \
    dotnet-sdk-7.0 \
    git

RUN apt-get clean &&     rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p ${BASE_DIR}\temp ${SD_INSTALL_DIR} /config/outputs

ADD parameters/* /opt/sd-install/parameters/

COPY --chown=abc:abc *.sh ./

RUN chmod +x /entry.sh

ENV XDG_CONFIG_HOME=/home/abc
ENV HOME=/home/abc
RUN mkdir /home/abc && \
    chown -R abc:abc /home/abc

RUN cd /tmp && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b && \
    rm Miniconda3-latest-Linux-x86_64.sh && \
    chown -R abc:abc /root && \
    chown -R abc:abc /opt/sd-install


EXPOSE 9000/tcp