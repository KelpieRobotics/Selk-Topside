sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-libav
sudo apt install gstreamer1.0-opencv
sudo apt install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev

sudo apt install -y libgtk-3-dev libopencv-dev libsdl2-dev libspdlog-dev cmake gcc g++ python3 python3-pip

sudo apt install -y python3-gi python3-gi-cairo gir1.2-gtk-4.0
pip install pycairo
pip install PyGObject
# calibrate cameras need to be on

python3 ./set_up/calibrate.py 5601 cam_1 --width 6 --height 8 --size 7

python3 ./set_up/calibrate.py 5602 cam_2 --width 6 --height 8 --size 7

python3 ./set_up/calibrate.py 5603 cam_3 --width 6 --height 8 --size 7