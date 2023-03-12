#!/usr/bin/env python
# coding: utf-8

# In[1]:


import torch
from imagen_pytorch import Unet3D, ElucidatedImagen, ImagenTrainer
from nslt_dataset import NSLT
import torchvision.transforms as T
import ipywidgets as widgets
import wandb
import os

import cv2
import numpy as np


# In[ ]:

os.environ['WANDB_MODE'] = 'offline'


# In[2]:
num_frames = 64

# send_email('./samples/', ['sample-22_book.gif'], 'yeaaah')
mode = 'rgb'
root = {'word': './WLASL2000/'}

dataset = NSLT('./preprocess/nslt_100.json', 'train', root=root, mode='rgb', transforms=None, num_frames=num_frames)
val_dataset = NSLT('./preprocess/nslt_100.json', 'test', root=root, mode='rgb', transforms=None, num_frames=num_frames)


# In[3]:


unet1_dim = 128
unet2_dim = 256
downsample_factor = 2

unet1 = Unet3D(
    dim = unet1_dim, 
    dim_mults = (1, 2, 4, 8),
    
    lowres_cond = True,
).cuda()

unet2 = Unet3D(
    dim = unet2_dim, 
    dim_mults = (1, 2, 4, 8),
    
    lowres_cond = True,
).cuda()

# elucidated imagen, which contains the unets above (base unet and super resoluting ones)

imagen = ElucidatedImagen(
    unets = (unet1, unet2),
    image_sizes = (16, 32),
    random_crop_sizes = (None, 8),
    temporal_downsample_factor = (downsample_factor, 1),        # in this example, the first unet would receive the video temporally downsampled by 2x
    num_sample_steps = 10,
    cond_drop_prob = 0.1,
    sigma_min = 0.002,                          # min noise level
    sigma_max = (80, 160),                      # max noise level, double the max noise level for upsampler
    sigma_data = 0.5,                           # standard deviation of data distribution
    rho = 7,                                    # controls the sampling schedule
    P_mean = -1.2,                              # mean of log-normal distribution from which noise is drawn for training
    P_std = 1.2,                                # standard deviation of log-normal distribution from which noise is drawn for training
    S_churn = 30,                               # parameters for stochastic sampling - depends on dataset, Table 5 in apper
    S_tmin = 0.01,
    S_tmax = 1,
    S_noise = 1.007,
    # text_encoder_name = 't5-large',
    
).cuda()


# In[4]:




# In[5]:


# for x,y in enumerate(dataset, 0):
#     if x<3:
#         print(y[0].size())
#         print(y[1])
#     else:
#         break


# In[6]:


batch_size = 8

trainer = ImagenTrainer(
    imagen,
    lr = 1e-4,
    
).cuda()
trainer.add_train_dataset(dataset, batch_size=batch_size)
trainer.add_valid_dataset(val_dataset, batch_size=batch_size)


# In[7]:


texts = [
    'book',
    'all',
    'yes',
    'no',
    'birthday',
    'woman',
]
# trainer.save(f'./checkpoint{1}.pt')
# trainer.load(f'checkpoint{1}.pt')
# trainer.load(f'checkpoint{2}.pt')
# loss = trainer.train_step(unet_number = unet_training, max_batch_size = 4)
print('done')


# In[ ]:


unet_training = 1
train_steps = 100000
run_id = None
ignore_time = False
if trainer.is_main:
    config = {
        "train_steps": train_steps,
        "batch_size": batch_size,
        "downsample_factor": downsample_factor,
        "unet1_dim": unet1_dim,
        "unet2_dim": unet2_dim,
        "unet_training": unet_training,
        "num_frames": num_frames,
        "ignore_time": ignore_time,
        }
    wandb.init(project="vid-signs", entity="jadens_team", id=run_id, config=config)
    run_id = wandb.run.id

start_checkpoint_id = '19hj6x64'
def go():
    import os.path
    fname = f'samples/{start_checkpoint_id}-checkpoint.pt'
    if (os.path.isfile(fname)): 
        trainer.load(fname)

    max_batch_size = batch_size
    running_totals = []
    overview = []
    print(f'running the {run_id} model')
    for i in range(train_steps):
        loss = trainer.train_step(unet_number = unet_training, max_batch_size = max_batch_size, ignore_time = ignore_time)

        if not (i % 2000) and not i==0:
            print(f"trying to save a checkpoint, but is main? {trainer.is_main}")
            trainer.save(f'./{fname}')

        if not trainer.is_main: # is_main makes sure this can run in distributed
            continue
        
        running_totals.append(loss)
        wandb.log({"loss": loss})

        # if not (i % 50) and not i==0:
        #     print(f'avg_loss: {sum(running_totals[-30:])/30}')
        #     wandb.log({"30_loss": sum(running_totals[-30:])/30})

        if not (i % 400) and not i==0:
            valid_loss = trainer.valid_step(unet_number = unet_training, max_batch_size = max_batch_size, ignore_time = ignore_time)
            print(f'valid loss: {valid_loss}')
            wandb.log({"valid_loss": valid_loss})

        if (not (i % 1000)) and (not i==0): 
            overview_total = sum(running_totals)/len(running_totals)
            print(f'on step {i}, avg loss of last 200 steps: {overview_total}')
            del running_totals[:]
            overview.append(overview_total)
            videos = trainer.sample(texts = texts, video_frames = downsample_factor*20 if not ignore_time else 1, stop_at_unet_number=unet_training)
            # catch the images and animate them.
            pil_images = []
            for x in videos:
                vid = x
                vid = np.asarray(vid.cpu(), dtype=np.float32).transpose([1,2,3,0])
                vid = (vid+1)/2
                vid = [cv2.cvtColor(x, cv2.COLOR_RGB2BGR) for x in vid]
                vid = [T.ToPILImage()( (x*255).astype('uint8')) for x in vid]
                pil_images.append(vid)

            print("sampling done sampling")
            for x,img in enumerate(pil_images):
                img[0].save(f'./samples/sample-{run_id}-{i//200}_{texts[x]}.gif', format='GIF', save_all = True, 
                            append_images = pil_images[x][1:],
                            optimize = False, duration = 200, loop=0,
                            disposal=3,
                           )
                print(f"logging image {texts[x]} on wandb")
                wandb.log({f"example_{texts[x]}": wandb.Image(f'./samples/sample-{run_id}-{i//200}_{texts[x]}.gif')})
            print('finished saving images')
            wandb.log({"avg_loss": overview_total, "step": i})

    trainer.save(f'.{fname}')


go()