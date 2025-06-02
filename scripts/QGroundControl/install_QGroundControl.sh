#!/usr/bin/env bash

sudo usermod -a -G dialout $USER # TODO: Check if $USER already in dialout
mkdir -p /home/$USER/Applications
curl -o /home/$USER/Applications/QGroundControl.AppImage https://d176tv9ibo4jno.cloudfront.net/latest/QGroundControl.AppImage
sudo chmod +x /home/$USER/Downloads/Installers/AppImage/QGroundControl.AppImage
