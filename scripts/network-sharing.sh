#!/usr/bin/bash

ETHERNET_INTERFACE=enp42s0
WIFI_INTERFACE=wlo1

sudo systemctl start isc-dhcp-server
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -A FORWARD -i ${ETHERNET} -j ACCEPT
sudo iptables -t nat -A POSTROUTING -o ${WIFI} -j MASQUERADE

