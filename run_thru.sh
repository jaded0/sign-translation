git clone -b vid-signs https://github.com/jaded0/sign-translation.git 

module load charliecloud/0.26
cd sign-translation/
ch-image build --force -t vid-signs .
ch-builder2tar vid-signs /tmp
# mkdir ${HOME}/samples
mkdir /tmp/tags
ch-tar2dir /tmp/vid-signs.tar.gz /tmp/tags # unpack the container

# run it once through to download stuff
ch-run \
-w \
--no-home \
-b ${HOME}/samples:/root/sign-translation/samples \
-c /root/sign-translation \
/tmp/tags/vid-signs/ -- \
bash ./training.sh

# run it again to actually train
sbatch --output ./output_results.txt --mail-user jaden.lorenc@gmail.com --job-name "vid-signs" run_vid-signs_tag.sh