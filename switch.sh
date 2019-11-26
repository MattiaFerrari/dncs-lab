export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump
apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common

ovs-vsctl add-br switch

ovs-vsctl add-port switch en1
ovs-vsctl add-port switch en2
ovs-vsctl add-port switch en3

ip link set en1 up
ip link set en2 up
ip link set en3 up

ip link set dev ovs-system up
