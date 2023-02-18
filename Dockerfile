FROM nvidia/cuda:11.2.1-cudnn8-devel-ubuntu20.04         
                                                                                 
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
WORKDIR /root

RUN apt-get update \
    && apt-get install -y wget git unzip libgl1 vim \
    && rm -rf /var/lib/apt/lists/* \
    && wget \
      https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && export HOME=/root \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh \
    && export PATH="/root/miniconda3/bin:${PATH}"
                                                                                 
RUN git clone -b vid-signs https://github.com/jaded0/sign-translation.git \ 
    && cd sign-translation \
    && mkdir samples
                                                                                                                                                                  
RUN export PATH="/miniconda3/envs/base/bin:/miniconda3/bin:${PATH}" \
    && cd sign-translation \
    && conda install -y mamba -n base -c conda-forge \
    && mamba env create -f sign-env.yml 
                                                                                 
COPY WLASL2000.zip WLASL2000.zip                                                 

RUN export PATH="/miniconda3/envs/base/bin:/miniconda3/bin:${PATH}" \
    && mamba init bash                                
                                                                                 
RUN export PATH="/miniconda3/envs/base/bin:/miniconda3/bin:${PATH}" \
    && . /root/.bashrc \  
    && mamba activate sign-env \
    && unzip -q -d sign-translation/ WLASL2000.zip \
    && rm -f WLASL2000.zip \
    && cd sign-translation \
    && . /root/.bashrc \                                                            
    && mamba activate sign-env 