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

echo "72 hours of fun, 8 gpus"
# some helpful debugging options
set -e
set -u

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE

module load charliecloud/0.26

# ch-tar2dir "~/sign-translation.tar.gz" "~/tags" # unpack the container

# module load cuda
module load libnvidia-container
ch-fromhost --nvidia ~/tags/vid-signs/ # mount the container

# run it!
ch-run \
-w \
--no-home \
-b ${HOME}/samples:/root/sign-translation/samples \
-c /root/sign-translation \
~/tags/vid-signs/ -- \
bash ./training.sh