export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y tcpdump --assume-yes
apt-get install -y apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce --assume-yes --force-yes

docker pull -q dustnic82/nginx-test
docker run -d -p 80:80 dustnic82/nginx-test

ip link set dev enp0s8 up
ip addr add 7.7.40.1/23 dev enp0s8

ip route replace 7.7.10.0/26 via 7.7.40.254
ip route replace 7.7.20.0/23 via 7.7.40.254
#



