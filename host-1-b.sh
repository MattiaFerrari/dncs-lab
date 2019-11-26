export DEBIAN_FRONTEND=noninteractive

ip link set eth1 up
ip addr add 7.7.20.1/30 dev eth1

ip route add 7.7.40.0/23 via 7.7.20.254/23

