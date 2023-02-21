#!/bin/bash

/root/miniconda3/envs/sign-env/bin/accelerate launch --mixed_precision=fp16 --multi_gpu --num_processes=8 signgen.py
