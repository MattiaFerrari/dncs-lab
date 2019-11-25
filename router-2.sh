export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes
wget -O- https://apps3.cumulusnetworks.com/setup/cumulus-apps-deb.pubkey | apt-key add -
add-apt-repository "deb [arch=amd64] https://apps3.cumulusnetworks.com/repos/deb $(lsb_release -cs) roh-3"
apt-get update
apt-get install -y frr --assume-yes --force-yes

ip link set dev eth1 up
ip link set dev eth2 up
ip addr add 7.7.40.254/23 dev eth1 
ip addr add 7.7.30.2/30 dev eth2 




sysctl net.ipv4.ip_forward=1
ip route add 7.7.10.0 via 7.7.30.1/30   dev eth2
ip route add 7.7.20.0 via 7.7.30.1/30   dev eth2 
