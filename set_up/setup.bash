sudo apt install -y libgtk-3-dev libopencv-dev libsdl2-dev libspdlog-dev cmake gcc g++ python3 python3-pip

sudo apt install -y meson
sudo apt install -y ninja-build
# sudo meson install


git clone https://github.com/GStreamer/gst-plugins-bad.git
cd ./gst-plugins-bad

meson -C build
sudo ninja -C build install
cd ..

sudo apt install -y python3-gi python3-gi-cairo gir1.2-gtk-4.0
pip install pycairo
pip install PyGObject
# calibrate cameras need to be on

python3 ./set_up/calibrate.py 5600 cam_1 --width 6 --height 8 --size 7

python3 ./set_up/calibrate.py 5601 cam_2 --width 6 --height 8 --size 7

python3 ./set_up/calibrate.py 5602 cam_3 --width 6 --height 8 --size 7