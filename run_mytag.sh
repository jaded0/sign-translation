#!/bin/bash

#SBATCH --time=1:00:00   # walltime.  hours:minutes:seconds
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --gpus=1
#SBATCH --mem-per-cpu=64000M   # 64G memory per CPU core
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --qos=cs
#SBATCH --partition=cs

# some helpful debugging options
set -e
set -u

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE

module load charliecloud/0.26

# ch-tar2dir "~/sign-translation.tar.gz" "~/tags" # unpack the container

# module load cuda
module load libnvidia-container
ch-fromhost --nvidia ~/tags/sign-translation/ # mount the container

# run it!
ch-run \
-w \
--no-home \
-b ${HOME}/hf_models:/root/sign-translation/hf_models \
-b ${HOME}/output_model:/root/sign-translation/output_model \
-c /root/sign-translation \
~/tags/sign-translation/ -- \
./run_training.sh --max_train_steps=400 --local_files_only # the name of the command INSIDE THE CONTAINER that you want to run
