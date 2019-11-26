export DEBIAN_FRONTEND=noninteractive

ip link add link enp0s8 name enp0s8.1 type vlan id 1
ip link add link enp0s8 name enp0s88.2 type vlan id 2
ip link set dev enp0s8 up
ip link set dev enp0s8.1 up
ip link set dev enp0s8.2 up
ip addr add 7.7.10.62/26 dev enp0s8.1
ip addr add 7.7.20.254/23 dev enp0s8.2

ip link set dev enp0s9 up
ip addr add 7.7.30.1/30 dev enp0s9 

sysctl -w net.ipv4.ip_forward=1 > /dev/null
ip route add 7.7.40.0/23 via 7.7.30.2 dev enp0s9 
