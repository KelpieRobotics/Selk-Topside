sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-libav
sudo apt install gstreamer1.0-opencv
sudo apt install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev

sudo apt install -y libgtk-3-dev libopencv-dev libsdl2-dev libspdlog-dev cmake gcc g++ python3 python3-pip

sudo apt install -y python3-gi python3-gi-cairo gir1.2-gtk-4.0
pip install pycairo
pip install PyGObject
# calibrate cameras need to be on


gst-launch-1.0 -v udpsrc port=5601 caps="application/x-rtp, media=video, encoding-name=H264, payload=96" ! rtph264depay ! h264parse ! avdec_h264 ! videoconvert ! queue ! cameracalibrate pattern=chessboard board-width=6 board-height=8 square-size=7 show-corners=true frame-count=25 ! output=cam_1.xml ! videoconvert ! autovideosink

gst-launch-1.0 -v udpsrc port=5602 caps="application/x-rtp, media=video, encoding-name=H264, payload=96" ! rtph264depay ! h264parse ! avdec_h264 ! videoconvert ! queue ! cameracalibrate pattern=chessboard board-width=6 board-height=8 square-size=7 show-corners=true frame-count=25 ! output=cam_1.xml ! videoconvert ! autovideosink

gst-launch-1.0 -v udpsrc port=5603 caps="application/x-rtp, media=video, encoding-name=H264, payload=96" ! rtph264depay ! h264parse ! avdec_h264 ! videoconvert ! queue ! cameracalibrate pattern=chessboard board-width=6 board-height=8 square-size=7 show-corners=true frame-count=25 ! output=cam_1.xml ! videoconvert ! autovideosink