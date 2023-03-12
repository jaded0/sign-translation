module load charliecloud/0.26
# cd sign-translation/
ch-image build --force -t $1 .
ch-builder2tar $1 ${HOME}
# mkdir ${HOME}/samples
sbatch --output ./output_results_$1.txt --mail-user jaden.lorenc@gmail.com run_vid-signs_tag.sh $1