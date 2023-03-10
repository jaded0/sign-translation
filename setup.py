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