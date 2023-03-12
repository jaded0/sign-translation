to run, log into supercomputer with
```bash
ssh username@ssh.rc.byu.edu
```
and then run:

```bash
git clone -b vid-signs https://github.com/jaded0/sign-translation.git 

module load charliecloud/0.26
# cd sign-translation/
ch-image build --force -t vid-signs .
ch-builder2tar vid-signs ${HOME}
# mkdir ${HOME}/samples
# mkdir /tmp/tags
# ch-tar2dir ${HOME}/vid-signs.tar.gz /tmp/tags # unpack the container
sbatch --output ./output_results.txt --mail-user jaden.lorenc@gmail.com --job-name "vid-signs" run_vid-signs_tag.sh
```


to loop the wandb sync:
```chrontab
*/5 * * * * cd /home/jaded79/sign-translation && /home/jaded79/.local/bin/wandb sync --sync-all
```