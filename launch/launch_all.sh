#!/usr/bin/bash

# sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y
# sudo apt install libfuse2 -y
# sudo apt install libxcb-xinerama0 libxkbcommon-x11-0 libxcb-cursor-dev -y
# sudo apt-get install libpulse-mainloop-glib0

# sudo usermod -a -G dialout $USER # (one time only)
# sudo apt-get remove modemmanager -y # (logout and login again to enable the change to user permissions)

# sudo apt install parallel
# sudo apt-get install xdotool
# sudo apt-get install gnome-terminal

# clear and define snippets & logs directory
rm -rf ./snippets/*
rm -rf ./logs/*
mkdir -p "./logs"
mkdir -p "./snippets"

# Image stitching
main_loop() {
    trap SIGINT
    sleep 1 # Small time to actually to kill the process
    # Just Spam CTRL-C 

    trap "capture_images" INT
    
    parallel -j2 run_pipeline ::: 1 3 6 #5 # choose which pipelines to run

    trap SIGINT 

    exit
}

capture_images () {
    trap SIGINT
    sleep 1 # Small time to actually to kill the process

    trap "stitch_images" INT

    rm -rf ./source_images ./tmp;
    mkdir ./source_images ./tmp;

    parallel -j2 run_pipeline ::: 1 3-alt 6 #5 # choose which pipelines to run
  
    stitch_images
}

stitch_images() {
    trap SIGINT
    sleep 1 # Small time to actually to kill the process
    trap "main_loop" INT;
    python3 ./stitch.py;
    # python3 ; # main.py should create a subproccess that listens to node and saves to specific folder & also stitches images
    trap SIGINT;
    $XPANO;
    ./main.bash;
    exit
}


# function to run gnu parallels
run_pipeline() {
    case $1 in
        1)
          # chmod +x ./QGroundControl.AppImage # uncomment if needed
          # launch qgroundcontrol (camera 1 preview + logs)
          ./QGroundControl.AppImage 2>&1 | tee "logs/qgroundcontrol.log" # errors included in logs
          ;;
        2)
          # save snippets from camera 1 + log output (background to free up terminal)
          gst-launch-1.0 -v udpsrc port=5600 \
            caps='application/x-rtp,media=video,clock-rate=90000,encoding-name=(string)H264, payload=(int)96, width=(int)160, height=(int)120' \
            ! rtph264depay ! h264parse ! avdec_h264 \
            ! queue ! videorate ! video/x-raw,framerate=0.2/1 \
            ! jpegenc ! multifilesink location="snippets/frame-%05d.jpg" \
            2>&1 | tee "logs/stream1.log" &
          ;;
        3)
          # preview camera 2 + log output
          gst-launch-1.0 -v udpsrc port=5601 \
            caps='application/x-rtp,media=video,clock-rate=90000,encoding-name=(string)H264, payload=(int)96, width=(int)160, height=(int)120' \
            ! rtph264depay ! h264parse ! avdec_h264 \
            ! queue ! videoconvert ! autovideosink \
            2>&1 | tee "logs/stream2.log" &
          ;;
        3-alt)
          # preview camera 2 + log output
          gst-launch-1.0 -v udpsrc port=5601 \
            caps='application/x-rtp,media=video,clock-rate=90000,encoding-name=(string)H264, payload=(int)96, width=(int)160, height=(int)120' \
            ! rtph264depay ! h264parse ! avdec_h264 \
            ! queue ! videoconvert ! autovideosink \
            2>&1 | tee "logs/stream2.log" &
          ;;
        4)
          # preview camera 3 + log output
          gst-launch-1.0 -v udpsrc port=5602 \
            caps='application/x-rtp,media=video,clock-rate=90000,encoding-name=(string)H264, payload=(int)96, width=(int)160, height=(int)120' \
            ! rtph264depay ! h264parse ! avdec_h264 \
            ! queue ! videoconvert ! autovideosink \
            2>&1 | tee "logs/stream3.log" &
          ;;
        5)
          # give time for windows to initialize
          sleep 10

          # get window IDs
          QGC_ID=$(xdotool search --name "QGroundControl" | head -n 1)
          CAM1_ID=$(xdotool search --name "OpenGL" | sed -n '1p')
          CAM2_ID=$(xdotool search --name "OpenGL" | sed -n '2p')

          # window IDs
          echo "QGroundControl window ID: $QGC_ID"
          echo "Camera 1 window ID: $CAM1_ID"
          echo "Camera 2 window ID: $CAM2_ID"

          # move and resize windows
          # move QGroundControl to the left
          xdotool windowmove $QGC_ID 0 0
          xdotool windowsize $QGC_ID 960 1080

          # move Camera 1 to the top-right
          xdotool windowmove $CAM1_ID 960 0
          xdotool windowsize $CAM1_ID 960 540

          # move Camera 2 to the bottom-right
          xdotool windowmove $CAM2_ID 960 540
          xdotool windowsize $CAM2_ID 960 540
          ;;
        6)
          SERVER_DIR="./rov-sensor-broadcaster/src"

          # build and run server
          g++ -o server.o $SERVER_DIR/ds18b20/ds18b20.cpp $SERVER_DIR/sht30/sht30.cpp $SERVER_DIR/server.cpp
          sudo ./server.o
          ;;
    esac
}

export -f run_pipeline

# run all pipelines in parallel
# parallel -j2 run_pipeline ::: 1 3 6 #5 # choose which pipelines to run

main_loop