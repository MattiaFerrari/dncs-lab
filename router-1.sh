export DEBIAN_FRONTEND=noninteractive

ip link add link enp0s8 name enp0s8.10 type vlan id 10
ip link add link enp0s8 name enp0s8.20 type vlan id 20
ip link set dev enp0s8 up
ip link set dev enp0s8.10 up
ip link set dev enp0s8.20 up
ip addr add 7.7.10.62/26 dev enp0s8.10
ip addr add 7.7.20.254/23 dev enp0s8.20

ip link set dev enp0s9 up
ip addr add 7.7.30.1/30 dev enp0s9 

sysctl -w net.ipv4.ip_forward=1 > /dev/null
ip route add 7.7.40.0/23 via 7.7.30.2
