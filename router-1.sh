export DEBIAN_FRONTEND=noninteractive

ip link set eth1 up
ip addr add 7.7.10.62/26 dev en1
ip addr add 7.7.20.254/23 dev en1

ip link set dev eth2 up
ip addr add 7.7.30.1/30 dev en2 

sysctl -w net.ipv4.ip_forward=1 > /dev/null
ip route add 7.7.40.0/23 via 7.7.30.2/30 dev en2 
