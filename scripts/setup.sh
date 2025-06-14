#!/bin/bash

# Create required directories
mkdir -p /opt/kelpie/scripts


# Configure packages
add-apt-repository universe -y
apt update

# Upgrade installed packages
sudo apt full-upgrade

# Installed common packages
apt install -y \
  openssh-server \
  curl \
  libqt5core5a \
  libqt5dbus5 \
  libqt5gui5 \
  libqt5widgets5 \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-libav \
  gstreamer1.0-gl \
  libfuse2 \
  libxcb-xinerama0 \
  libxkbcommon-x11-0 \
  libxcb-cursor-dev

# Remove unused dependencies
apt autoremove -y

# # Install AppImageLauncher
# mkdir -p /home/$USER/Downloads/Installers/deb/
# curl -Lo /home/$USER/Downloads/Installers/deb/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb
# sudo dpkg -i /home/$USER/Downloads/Installers/deb/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb


# TODO: remove the help app
# TODO: nvidia graphics driver switcher through terminal
# TODO; remove grub splash
# TODO: Install ROS2 


## Install configuration files

## Install unit file

## Enable and start network sharing service
