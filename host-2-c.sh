apt-get update
apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io

ip addr add 7.7.20.1/23 dev eth1
ip link set eth1 up

docker pull -q dustnic82/nginx-test
docker run -d -p 80:80 dustnic82/nginx-test
