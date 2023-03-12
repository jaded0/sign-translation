#!/bin/bash
export UNIQUE_ID=$(date +%s)

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
#SBATCH --job-name=${UNIQUE_ID}

echo "72 hours of fun, 8 gpus"
# some helpful debugging options
set -e
set -u

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE

module load charliecloud/0.26

mkdir /tmp/tags
ch-tar2dir ${HOME}/vid-signs.tar.gz /tmp/tags # unpack the container


# module load cuda
module load libnvidia-container
mkdir /tmp/tags/vid-signs/$UNIQUE_ID
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