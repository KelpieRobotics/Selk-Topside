#!/usr/bin/env python3

import gi
import sys
import time
import argparse
import os

gi.require_version('Gst', '1.0')
from gi.repository import Gst, GObject

Gst.init(None)

def create_pipeline(port: int, width: int, height: int, square_size: float) -> str:
    return f"""
udpsrc port={port} caps="application/x-rtp, media=video, encoding-name=H264, payload=96" ! rtph264depay ! h264parse ! avdec_h264 ! videoconvert ! queue ! cameracalibrate pattern=chessboard board-width={width} board-height={height} square-size={square_size} show-corners=true frame-count=25 name=calib ! videoconvert ! autovideosink
"""

def calibrate_camera(pipeline_desc: str, file_name: str):
    input("Press Enter to begin calibration...")

    pipeline = Gst.parse_launch(pipeline_desc)
    calib = pipeline.get_by_name("calib")

    if not calib:
        print("Could not get cameracalibrate element")
        sys.exit(1)

    pipeline.set_state(Gst.State.PLAYING)

    print("Waiting for calibration data...")
    settings = ""
    try:
        while not settings:
            time.sleep(0.5)
            settings = calib.get_property("settings")
    except KeyboardInterrupt:
        print("\nCalibration cancelled by user.")
        pipeline.set_state(Gst.State.NULL)
        sys.exit(1)

    # Ensure output directory exists
    output_dir = os.path.join("calibrations")
    os.makedirs(output_dir, exist_ok=True)  # Create the full directory if not exists

    file_path = os.path.join(output_dir, f"{file_name}.xml")

    print(f"Calibration data received, saving to file: {file_path}")
    with open(file_path, "w") as f:
        f.write(settings)

    print(f"Saved calibration data to {file_path}")
    pipeline.set_state(Gst.State.NULL)

    # Return the file path for use in bash
    print(file_path)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Camera calibration tool using GStreamer.")
    parser.add_argument("port", type=int, help="UDP port to receive video stream")
    parser.add_argument("file_name", type=str, help="File name to save calibration data (without extension)")
    parser.add_argument("--width", type=int, default=9, help="Chessboard width (default: 9)")
    parser.add_argument("--height", type=int, default=6, help="Chessboard height (default: 6)")
    parser.add_argument("--size", type=float, default=0.025, help="Chessboard square size in meters (default: 0.025)")

    args = parser.parse_args()

    pipeline_desc = create_pipeline(args.port, args.width, args.height, args.size)
    calibrate_camera(pipeline_desc, args.file_name)
