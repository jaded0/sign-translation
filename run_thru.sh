module load charliecloud/0.26
# cd sign-translation/
ch-image build --force -t vid-signs .
ch-builder2tar vid-signs ${HOME}
# mkdir ${HOME}/samples
sbatch --output ./output_results3.txt --mail-user jaden.lorenc@gmail.com run_vid-signs_tag.sh