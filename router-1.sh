export DEBIAN_FRONTEND=noninteractive

ip link set eth1 up
ip addr add 7.7.10.62/26 dev eth1
ip addr add 7.7.20.254/23 dev eth1

ip link set dev eth2 up
ip addr add 7.7.30.1/30 dev eth2 

sysctl -w net.ipv4.ip_forward=1 > /dev/null
ip route add 7.7.40.0 via 7.7.30.2/30 dev eth2 
