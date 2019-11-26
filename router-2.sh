export DEBIAN_FRONTEND=noninteractive

ip link set dev enp0s8 up
ip addr add 7.7.40.254/23 dev enp0s8 

ip link set dev enp0s9 up
ip addr add 7.7.30.2/30 dev enp0s9 

sysctl -w net.ipv4.ip_forward=1 > /dev/null
ip route add 7.7.10.0/26 via 7.7.30.1
ip route add 7.7.20.0/23 via 7.7.30.1  
