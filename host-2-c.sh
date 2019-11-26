apt-get -qq update
apt-get -qq install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get -qq update
apt-get -qq install docker-ce docker-ce-cli containerd.io

ip link set dev enp0s8 up
ip addr add 7.7.20.1/23 dev enp0s8

ip route add 7.7.20.0/23 via 7.7.40.254
ip route add 7.7.10.0/26 via 7.7.40.254


docker pull -q dustnic82/nginx-test
docker run -d -p 80:80 dustnic82/nginx-test
