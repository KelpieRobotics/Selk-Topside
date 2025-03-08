import os
from typing import List, Tuple, Optional
import subprocess

from multiprocessing import Process, Pipe
from multiprocessing.connection import Connection

import uuid

def crop_image(image, crop_width, crop_height):
    width, height = image.size
    left = (width - crop_width) / 2
    top = (height - crop_height) / 2
    right = (width + crop_width) / 2
    bottom = (height + crop_height) / 2
    return image.crop((left, top, right, bottom))

def _merge_images(images: List[str], output_name: str, output_conn: Connection, crop: Optional[Tuple[int, int]]):
    process = subprocess.Popen(
        ["./xpano/build/xpano", *[f"{name}" for name in images], f"--output={output_name}"],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1
    )
    
    try:
        for line in process.stdout:
            print(line, end="")
            try:
                output_conn.send(line)
            except BrokenPipeError:
                break

    finally:
        process.wait()
        print("Process has terminated.")
        try:
            output_conn.send("Process has terminated.\n")
            output_conn.close()
        except BrokenPipeError:
            pass
    if crop is not None:
        image = Image.open(f"{output_name}")
                
        # Crop the image from the center
        cropped_image = crop_image(image, *crop)
        
        # Save the cropped image
        cropped_image.save(os.path.join(f"{output_name}"))
        print(f"Saved cropped image tmp/{output_name}")


def merge_images(images: List[str], output_name:str, crop: Optional[Tuple[int, int]]) -> Tuple[Process, Connection]:
    tx, rx = Pipe()

    process = Process(
        target=_merge_images,
        args=(images, output_name, tx, crop)
    )

    process.start()

    return (process, rx)

def windowed_stitching(directory: str, window_size: int, overlap: int = 1) -> List[str]:
    files = sorted(
        [f"./source_images/{f}" for f in os.listdir(directory) if os.path.isfile(os.path.join(directory, f))],
        key=lambda x: int(os.path.basename(x).split('.')[0])  # Extract numeric part and sort
    )
    new_files=[]
    while len(files) > 0:
        processes = []
        new_files = []

        if len(files) < window_size:
            file_name= f"./tmp/{uuid.uuid4().hex}.png"
        
            processes.append(
                merge_images(
                    files,
                    file_name,
                    None
                )
            )
        else:
            for idx in range(len(files) // (window_size - overlap)):
                file_name= f"./tmp/{uuid.uuid4().hex}.png"
                
                new_files.append(file_name)
                
                if idx == 0:
                    window = files[max(idx*window_size, 0):min((idx+1)*window_size, len(files))]

                    if len(window) < 2:
                        new_files.append(*window)
                        break

                    print(f"{window} -> {file_name}")
                    processes.append(
                        merge_images(
                            window,
                            file_name,
                            None
                        )
                    )
                else:
                    window = files[max(idx*window_size-overlap*idx, 0):min((idx+1)*window_size-overlap*idx, len(files))]
                    
                    if len(window) < 2:
                        new_files.append(*window)
                        break
                    print(f"{window} -> {file_name}")


                    processes.append(
                        merge_images(
                            window,
                            file_name,
                            None
                        )
                    )
                    
            
        while len(processes):
            processes.pop()[0].join()

        files=new_files
    
    return new_files

if __name__ == "__main__":
    windowed_stitching("./source_images", 7)