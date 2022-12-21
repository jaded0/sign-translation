
FROM --platform=linux/x86_64 nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
WORKDIR /root

RUN apt-get update \
    && apt-get install -y wget git \
    && rm -rf /var/lib/apt/lists/* \
    && wget \
      https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh \
    && conda --version

RUN git clone https://github.com/jaded0/sign-translation.git

COPY WLASL2000.zip WLASL2000.zip

RUN apt-get install -y unzip \
    && unzip -q WLASL2000.zip 
