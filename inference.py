
from diffusers import StableDiffusionPipeline
import torch

model_id = "./output_model"
pipe = StableDiffusionPipeline.from_pretrained(model_id, torch_dtype=torch.float16).to("cuda")

prompt = "sign language for: book"
#prompt = "PaperCut sks rubber duck at the beach"
#prompt = "woolitize, sks rubber duck in bright green grass, sun in background, fluffy, daisies"

image = pipe(prompt, num_inference_steps=50, guidance_scale=7.5).images[0]

image.save("output_model/book-signed.png")