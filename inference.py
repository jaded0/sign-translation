
from diffusers import StableDiffusionPipeline
import torch
import argparse
import os


def parse_args(arg_list=None):
    parser = argparse.ArgumentParser(description="Simple inference script.")
    parser.add_argument(
        "--num_inference_steps",
        type=int,
        default=50,
        help=(
            "Number of inference steps. If not provided, will 50. "
        ),
    )

    args = parser.parse_args(arg_list)

    return args

def main(arg_list=None):
    args = parse_args(arg_list=arg_list)
    model_id = "./output_model"
    pipe = StableDiffusionPipeline.from_pretrained(model_id, torch_dtype=torch.float16).to("cuda")

    prompt = "sign language for: book"
    #prompt = "PaperCut sks rubber duck at the beach"
    #prompt = "woolitize, sks rubber duck in bright green grass, sun in background, fluffy, daisies"

    image = pipe(prompt, num_inference_steps=args.num_inference_steps, guidance_scale=7.5).images[0]

    image.save("output_model/book-signed.png")

if __name__ == "__main__":
    main()