#!/bin/bash

PATH=/usr/sbin:/sbin:/bin:/usr/bin

#### MACHINES ####

dt03=10.0.0.20
web=10.0.0.17
server02=10.0.0.5

##################

#
# delete all existing rules.
#
iptables -F
iptables -t nat -F
iptables -t mangle -F
iptables -X

# Always accept loopback traffic
iptables -A INPUT -i lo -j ACCEPT

# Allow established connections, and those not coming from the outside
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state NEW -i eth0 -j ACCEPT
iptables -A INPUT -m state --state NEW -i lo -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow outgoing connections from the LAN side.
iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT

# Masquerade.
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

# Don't forward from the outside to the inside.
# iptables -A FORWARD -i eth1 -o eth0 -j REJECT

# Enable routing.
echo 1 > /proc/sys/net/ipv4/ip_forward

# NAT port forwarding
# -----------------------------

# port 80
iptables -A PREROUTING -t nat -i eth1 -p tcp --dport 80 -j DNAT --to $web
iptables -A INPUT -p tcp -m state --state NEW --dport 80 -i eth1 -j ACCEPT
# port 443
iptables -A PREROUTING -t nat -i eth1 -p tcp --dport 443 -j DNAT --to $web
#iptables -A INPUT -p tcp -m state --state NEW --dport 443 -i eth1 -j ACCEPT

# ssh
iptables -A PREROUTING -t nat -i eth1 -p tcp --dport 22 -j DNAT --to $dt03
iptables -A INPUT -p tcp -m state --state NEW --dport 22 -i eth1 -j ACCEPT
# mosh
iptables -A PREROUTING -t nat -i eth1 -p udp --dport 60000:61000 -j DNAT --to $dt03
iptables -A INPUT -p udp -m state --state NEW --dport 60000:61000 -i eth1 -j ACCEPT

# ---- Counter Strike server
# 1200
iptables -A PREROUTING -t nat -i eth1 -p udp --dport 1200 -j DNAT --to $dt03
iptables -A INPUT -p tcp -m state --state NEW --dport 1200 -i eth1 -j ACCEPT
# 27000-27015
iptables -A PREROUTING -t nat -i eth1 -p udp --dport 27000:27015 -j DNAT --to $dt03
iptables -A INPUT -p udp -m state --state NEW --dport 27000:27015 -i eth1 -j ACCEPT
# 27020-27039
iptables -A PREROUTING -t nat -i eth1 -p udp --dport 27020:27039 -j DNAT --to $dt03
iptables -A INPUT -p udp -m state --state NEW --dport 27020:27039 -i eth1 -j ACCEPT

# -----------------------------

