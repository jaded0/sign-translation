#!/bin/bash

#SBATCH --time=0:00:30   # walltime.  hours:minutes:seconds
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --gpus=1
#SBATCH --mem-per-cpu=64000M   # 64G memory per CPU core
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#not needed --qos=cs
#not needed --partition=cs

# some helpful debugging options
set -e
set -u

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE

module load charliecloud/0.26

# module load cuda
module load libnvidia-container
ch-fromhost --nvidia ~/tags/sign-translation/ # mount the container

ch-run \
-w \
--no-home \
-b ${HOME}/hf_models:/root/sign-translation/hf_models \
-b ${HOME}/output_model:/root/sign-translation/output_model \
-c /root/sign-translation \
~/tags/sign-translation/ -- \
/miniconda3/envs/sign-env/bin/accelerate launch inference.py --num_inference_steps $1 