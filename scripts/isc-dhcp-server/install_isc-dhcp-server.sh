#!/usr/bin/env bash

sudo apt install isc-dhcp-server

# Disable DHCP server auto-start
sudo systemctl stop isc-dhcp-server.service
sudo systemctl stop isc-dhcp-server6.service
sudo systemctl disable isc-dhcp-server.service
sudo systemctl disable isc-dhcp-server6.service
