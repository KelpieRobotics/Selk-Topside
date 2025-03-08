git clone "https://github.com/krupkat/xpano.git"
cd ./xpano
sudo apt install -y libgtk-3-dev libopencv-dev libsdl2-dev libspdlog-dev cmake gcc g++ python3
./misc/build/build-ubuntu-22.sh

cd ./xpano/build

export XPANO="$(pwd)/xpano"

cd ..
cd ..