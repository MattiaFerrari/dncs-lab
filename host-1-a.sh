export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump curl traceroute --assume-yes
apt install -y curl --assume-yes
ip link set eth1 up
ip addr add 7.7.10.1/30 dev eth1


