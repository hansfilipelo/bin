#!/bin/bash

PATH=/usr/sbin:/sbin:/bin:/usr/bin

#### INTERFACES ####

external=eth1
internal=eth0

#### MACHINES ####

dt03=10.0.0.20
web=10.0.0.17
server02=10.0.0.5

##################
#### PROTOCOLS ####

ssh=22
http=80
https=443

####################


# delete all existing rules.
iptables -F
iptables -t nat -F
iptables -t mangle -F
iptables -X

# --------------------------
# Set up NAT so clients can access internet
# Always accept loopback traffic
iptables -A INPUT -i lo -j ACCEPT
# Allow established connections, and those not coming from the outside
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state NEW -i $internal -j ACCEPT
iptables -A INPUT -m state --state NEW -i lo -j ACCEPT
iptables -A FORWARD -i $external -o $internal -m state --state ESTABLISHED,RELATED -j ACCEPT
# Allow outgoing connections from the LAN side.
iptables -A FORWARD -i $internal -o $external -j ACCEPT
# Masquerade - necessary for NAT
iptables -t nat -A POSTROUTING -o $external -j MASQUERADE
# Enable routing.
echo 1 > /proc/sys/net/ipv4/ip_forward
# -------------
# Don't forward from the outside to the inside.
# iptables -A FORWARD -i $external -o $internal -j REJECT

# ---------------------------------------------
# QoS for better performance

# Sonos to Spotify
iptables -t mangle -A PREROUTING -p tcp --sport 4070 -j TOS --set-tos Minimize-Delay
iptables -t mangle -A PREROUTING -p tcp --dport 4070 -j TOS --set-tos Minimize-Delay
# Web traffic (Sonos use this as well
iptables -t mangle -A PREROUTING -p tcp --sport $http -j TOS --set-tos Minimize-Delay
iptables -t mangle -A PREROUTING -p tcp --dport $http -j TOS --set-tos Minimize-Delay
iptables -t mangle -A PREROUTING -p tcp --sport $https -j TOS --set-tos Minimize-Delay
iptables -t mangle -A PREROUTING -p tcp --dport $https -j TOS --set-tos Minimize-Delay

# SSH
iptables -t mangle -A PREROUTING -p tcp --sport $ssh -j TOS --set-tos Minimize-Delay
iptables -t mangle -A PREROUTING -p tcp --dport $ssh -j TOS --set-tos Minimize-Delay

# NAT port forwarding for services
# ---------------------------------------------

# port 80
iptables -A PREROUTING -t nat -i $external -p tcp --dport $http -j DNAT --to $web
iptables -A INPUT -p tcp -m state --state NEW --dport $http -i $external -j ACCEPT
# port 443
iptables -A PREROUTING -t nat -i $external -p tcp --dport $https -j DNAT --to $web
iptables -A INPUT -p tcp -m state --state NEW --dport $https -i $external -j ACCEPT

# ssh
iptables -A PREROUTING -t nat -i $external -p tcp --dport $ssh -j DNAT --to $dt03
iptables -A INPUT -p tcp -m state --state NEW --dport $ssh -i $external -j ACCEPT

# mosh
iptables -A PREROUTING -t nat -i $external -p udp --dport 60000:61000 -j DNAT --to $dt03
iptables -A INPUT -p udp -m state --state NEW --dport 60000:61000 -i $external -j ACCEPT

# BitTorrent
#iptables -A PREROUTING -t nat -i $external -p tcp --dport 64795 -j DNAT --to $server02
#iptables -A INPUT -p tcp -m state --state NEW --dport 64795 -i $external -j ACCEPT

# ---- Counter Strike server
# 1200
iptables -A PREROUTING -t nat -i $external -p udp --dport 1200 -j DNAT --to $dt03
iptables -A INPUT -p udp -m state --state NEW --dport 1200 -i $external -j ACCEPT
iptables -A PREROUTING -t nat -i $external -p tcp --dport 1200 -j DNAT --to $dt03
iptables -A INPUT -p tcp -m state --state NEW --dport 1200 -i $external -j ACCEPT
# 27000-27015
iptables -A PREROUTING -t nat -i $external -p udp --dport 27000:27015 -j DNAT --to $dt03
iptables -A INPUT -p udp -m state --state NEW --dport 27000:27015 -i $external -j ACCEPT
iptables -A PREROUTING -t nat -i $external -p tcp --dport 27000:27015 -j DNAT --to $dt03
iptables -A INPUT -p tcp -m state --state NEW --dport 27000:27015 -i $external -j ACCEPT
# 27020-27039
iptables -A PREROUTING -t nat -i $external -p udp --dport 27020:27039 -j DNAT --to $dt03
iptables -A INPUT -p udp -m state --state NEW --dport 27020:27039 -i $external -j ACCEPT
iptables -A PREROUTING -t nat -i $external -p tcp --dport 27020:27039 -j DNAT --to $dt03
iptables -A INPUT -p tcp -m state --state NEW --dport 27020:27039 -i $external -j ACCEPT

# -----------------------------
