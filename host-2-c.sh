export DEBIAN_FRONTEND=noninteractive
#sudo apt-get update
#sudo apt-get install -y tcpdump --assume-yes
#sudo apt install -y curl --assume-yes
#sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes
#sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
#sudo apt-key fingerprint 0EBFCD88 | grep docker@docker.com || exit 1
#sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
#sudo apt-get update
#sudo apt-get install -y docker-ce --assume-yes --force-yes

#docker run -d -p 80:80 dustnic82/nginx-test
ip link set dev enp0s8 up
ip addr add 7.7.40.1/23 dev enp0s8

ip route add default via 7.7.40.254



