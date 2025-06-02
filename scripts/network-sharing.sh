#!/usr/bin/bash

systemctl start isc-dhcp-server
sysctl -w net.ipv4.ip_forward=1
iptables -A FORWARD -i enx00e04c6802fe -j ACCEPT
iptables -t nat -A POSTROUTING -o wlp2s0 -j MASQUERADE

