
# module load python
# pip install --user wandb
# wandb login



import wandb
import os
import time

# print(os.environ['STEPS'])

wandb.init(project="test-project", entity="jadens_team")

train_steps = 3000
infer_steps = 30

# os.system("""sbatch --output ./output_results.txt --mail-user jaden.lorenc@gmail.com --job-name "dreambooth test" run_mytag.sh """ + str(train_steps))
# time.sleep(10)
for s in [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]:
    infer_steps = s
    for x in range(0, 4):
        os.system("""sbatch --output ./output_results.txt --mail-user jaden.lorenc@gmail.com --job-name "dreambooth test" getresults.sh """ + str(infer_steps))
        time.sleep(120)
        wandb.config = {
        "train_steps": train_steps,
        "batch_size": 16,
        "infer_steps": infer_steps,
        }

        # wandb.log({"loss": 20})

        wandb.log({"example": wandb.Image("/home/jaded79/output_model/book-signed.png")})