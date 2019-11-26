export DEBIAN_FRONTEND=noninteractive
ip link set dev enp0s8 up
ip addr add 7.7.10.1/26 dev enp0s8
ip route add 7.7.40.0 via 7.7.10.62/26

