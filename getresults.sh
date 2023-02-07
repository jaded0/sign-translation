

ch-run \
-w \
--no-home \
-b ${HOME}/hf_models:/root/sign-translation/hf_models \
-b ${HOME}/output_model:/root/sign-translation/output_model \
-c /root/sign-translation \
~/tags/sign-translation/ -- \
/miniconda3/envs/sign-env/bin/accelerate launch inference.py