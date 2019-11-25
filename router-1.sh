export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes
wget -O- https://apps3.cumulusnetworks.com/setup/cumulus-apps-deb.pubkey | apt-key add -
add-apt-repository "deb [arch=amd64] https://apps3.cumulusnetworks.com/repos/deb $(lsb_release -cs) roh-3"
apt-get update
apt-get install -y frr --assume-yes --force-yes

ip link add link eth1 name eth1.10 type vlan id 10
ip link add link eth2 name eth1.20 type vlan id 20
ip link set eth1 up
ip link set eth1.10 up
ip link set eth1.20 up
ip addr add 7.7.10.62/26 dev eth1.10 
ip addr add 7.7.20.254/23 dev eth1.20

ip link set dev eth2 up
ip addr add 7.7.30.1/30 dev eth2 




sysctl net.ipv4.ip_forward=1
sysctl net.ipv4.ip_forward=1
sed -i 's/zebra=no/zebra=yes/g' /etc/frr/daemons
sed -i 's/ospfd=no/ospfd=yes/g' /etc/frr/daemons
service frr restart
vtysh -c 'configure terminal' -c 'interface eth2' -c 'ip ospf area 0.0.0.0'
vtysh -c 'configure terminal' -c 'router ospf' -c 'redistribute connected'
ip route add 7.7.40.0 via 7.7.30.2/30   dev eth2 
