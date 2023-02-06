FROM --platform=linux/x86_64 nvidia/cuda:11.2.1-cudnn8-devel-ubuntu20.04         
                                                                                 
ENV PATH="/root/miniconda3/bin:${PATH}"                                          
ARG PATH="/root/miniconda3/bin:${PATH}"                                          
WORKDIR /root                                                                    
                                                                                 
RUN apt-get update \                                                             
    && apt-get install -y wget git unzip libgl1 vim \                            
    && rm -rf /var/lib/apt/lists/* \                                             
    && wget \                                                                    
      https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \       
    && mkdir /root/.conda \                                                      
    && bash Miniconda3-latest-Linux-x86_64.sh -b \                               
    && rm -f Miniconda3-latest-Linux-x86_64.sh \                                 
    && conda --version                                           
                                                                                 
RUN git clone -b stable_signs https://github.com/jaded0/sign-translation.git \                   
    && cd sign-translation \                                                     
    && mkdir samples                                                             
                                                                                 
COPY sign-env.yml sign-env.yml                                                   
                                                                                 
RUN conda install -y mamba -n base -c conda-forge                                
RUN mamba init bash                                                              
RUN mamba env create -f sign-env.yml                                             
RUN . /root/.bashrc \                                                            
    && mamba activate sign-env                                                   
                                                                                 
COPY WLASL2000.zip WLASL2000.zip                                                 
                                                                                 
RUN unzip -q -d sign-translation/ WLASL2000.zip \
    && rm -f WLASL2000.zip \
    && cd sign-translation \
    && . /root/.bashrc \                                                            
    && mamba activate sign-env