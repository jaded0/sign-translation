#!/bin/bash

# some helpful debugging options
set -e
set -u

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE

module load charliecloud/0.26

ch-tar2dir ${HOME}/sign-translation.tar.gz ${HOME}/tags # unpack the container

# module load cuda
# module load libnvidia-container
# ch-fromhost --nvidia ~/tags/sign-translation/ # mount the container

# run it!
ch-run \
-w \
--no-home \
-b ${HOME}/hf_models:/root/sign-translation/hf_models \
-b ${HOME}/output_model:/root/sign-translation/output_model \
-c /root/sign-translation \
~/tags/sign-translation/ -- \
./run_training.sh --max_train_steps=1 # the name of the command INSIDE THE CONTAINER that you want to run
