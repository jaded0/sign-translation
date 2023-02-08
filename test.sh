#!/bin/bash

#SBATCH --time=0:20:00   # walltime.  hours:minutes:seconds
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --gpus=1
#SBATCH --mem-per-cpu=64000M   # 64G memory per CPU core
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --qos=cs
#SBATCH --partition=cs

# This is secret and shouldn't be checked into version control
export WANDB_API_KEY=$YOUR_API_KEY
# Name and notes optional
# export WANDB_NAME="My first run"
# export WANDB_NOTES="Smaller learning rate, more regularization."
# Only needed if you don't checkin the wandb/settings file
export WANDB_ENTITY=$username
export WANDB_PROJECT=$project

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
/miniconda3/envs/sign-env/bin/accelerate launch test.py