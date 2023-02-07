to run, log into supercomputer with
```bash
ssh username@ssh.rc.byu.edu
```
and then run:

```bash
git clone -b stable_signs https://github.com/jaded0/sign-translation.git 

module load charliecloud/0.26
cd cs674-dreambooth/
ch-image build --force -t sign-translation .
ch-builder2tar mytag ${HOME}
mkdir ${HOME}/output_model
mkdir ${HOME}/hf_models
mkdir ${HOME}/tags
bash setup_mytag.sh
sbatch --output ./output_results.txt --mail-user YOUR_EMAIL_HERE --job-name "sign-translation" run_mytag.sh
```