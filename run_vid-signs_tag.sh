#!/bin/bash

#SBATCH --time=72:00:00   # walltime.  hours:minutes:seconds
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --gpus=8
#SBATCH --mem-per-cpu=256000M   # 64G memory per CPU core
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --qos=cs
#SBATCH --partition=cs
#SBATCH --job-name=vid-signs

echo "72 hours of fun, 8 gpus"
# some helpful debugging options
set -e
set -u

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE

module load charliecloud/0.26

export UNIQUE_ID=$1

mkdir /tmp/tags
ch-tar2dir ${HOME}/$1.tar.gz /tmp/tags # unpack the container


# module load cuda
module load libnvidia-container
mkdir -p /tmp/tags/vid-signs/$UNIQUE_ID
ch-fromhost --nvidia /tmp/tags/vid-signs/$UNIQUE_ID/ # mount the container

# run it!
ch-run \
-w \
--no-home \
-b ${HOME}/samples:/root/sign-translation/samples \
-b ${HOME}/sign-translation/wandb:/root/sign-translation/wandb \
-c /root/sign-translation \
--set-env=HF_HOME="/root/sign-translation/.cache/huggingface/" \
/tmp/tags/vid-signs/$UNIQUE_ID -- \
bash ./training.sh