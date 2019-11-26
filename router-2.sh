export DEBIAN_FRONTEND=noninteractive

ip link set dev eth1 up
ip addr add 7.7.40.254/23 dev en1 

ip link set dev eth2 up
ip addr add 7.7.30.2/30 dev en2 

sysctl -w net.ipv4.ip_forward=1 > /dev/null
ip route add 7.7.10.0/26 via 7.7.30.1/30   dev eth2
ip route add 7.7.20.0/23 via 7.7.30.1/30   dev eth2 
