#!/usr/bin/bash

ETH_IF="enp42s0"
WLO_IF="wlo1"

sudo systemctl start isc-dhcp-server
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -A FORWARD -i ${ETH_IF} -j ACCEPT
sudo iptables -t nat -A POSTROUTING -o ${WLO_IF} -j MASQUERADE

