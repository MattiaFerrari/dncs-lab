# DNCS-LAB

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


        +-----------------------------------------------------+
        |                                                     |
        |                                                     |eth0
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |            eth0|            |eth2     eth2|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |eth1                       |eth1
        |  N  |                      |                           |
        |  A  |                      |                           |
        |  G  |                      |                     +-----+----+
        |  E  |                      |eth1                 |          |
        |  M  |            +-------------------+           |          |
        |  E  |        eth0|                   |           |  host-c  |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |eth2         |eth3                |eth0
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |eth1         |eth1                |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |    eth0|          |     |          |             |
        |     +--------+  host-a  |     |  host-b  |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |eth0                   |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+



```

# Requirements
 - Python 3
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/dustnic/dncs-lab`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab]$ vagrant status                                                                                                                                                                
Current machine states:

router                    running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`
`vagrant ssh host-c`

# Assignment
This section describes the assignment, its requirements and the tasks the student has to complete.
The assignment consists in a simple piece of design work that students have to carry out to satisfy the requirements described below.
The assignment deliverable consists of a Github repository containing:
- the code necessary for the infrastructure to be replicated and instantiated
- an updated README.md file where design decisions and experimental results are illustrated
- an updated answers.yml file containing the details of 

## Design Requirements
- Hosts 1-a and 1-b are in two subnets (*Hosts-A* and *Hosts-B*) that must be able to scale up to respectively 35 and 269 usable addresses
- Host 2-c is in a subnet (*Hub*) that needs to accommodate up to 422 usable addresses
- Host 2-c must run a docker image (dustnic82/nginx-test) which implements a web-server that must be reachable from Host-1-a and Host-1-b
- No dynamic routing can be used
- Routes must be as generic as possible
- The lab setup must be portable and executed just by launching the `vagrant up` command

## Tasks
- Fork the Github repository: https://github.com/dustnic/dncs-lab
- Clone the repository
- Run the initiator script (dncs-init). The script generates a custom `answers.yml` file and updates the Readme.md file with specific details automatically generated by the script itself.
  This can be done just once in case the work is being carried out by a group of (<=2) engineers, using the name of the 'squad lead'. 
- Implement the design by integrating the necessary commands into the VM startup scripts (create more if necessary)
- Modify the Vagrantfile (if necessary)
- Document the design by expanding this readme file
- Fill the `answers.yml` file where required (make sure that is committed and pushed to your repository)
- Commit the changes and push to your own repository
- Notify the examiner that work is complete specifying the Github repository, First Name, Last Name and Matriculation number. This needs to happen at least 7 days prior an exam registration date.

# Notes and References
- https://rogerdudler.github.io/git-guide/
- http://therandomsecurityguy.com/openvswitch-cheat-sheet/
- https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/
- https://www.vagrantup.com/intro/getting-started/


# Design
## Subnets - Interfaces - IP mapping
| Subnet |Subnet ID | Device   | Interface | IP         |
|--------|----------|----------|-----------|------------|
| Hosts-A | 7.7.10.0|host-1-a | enp0s8      | 7.7.10.1/26 |
| Hosts-A      |7.7.10.0| router-1 | enp0s8.10   | 7.7.10.62/26 |
| Hosts-B      |7.7.20.0| host-1-b | enp0s8      | 7.7.20.1/23 |
| Hosts-B      |7.7.20.0| router-1 | enp0s8.20   | 7.7.21.254/23 |
| C      |7.7.30.0| router-1 | enp0s9       | 7.7.30.1/30 |
| C      |7.7.30.0| router-2 | enp0s9       | 7.7.30.2/30 |
| Hub      |7.7.40.0| host-2-c | enp0s8       | 7.7.40.1/23 |
| Hub      |7.7.40.0| router-2 | enp0s8       | 7.7.41.254/23 |


I choose for Subnet *Hosts-a* /26 because I need at least 35 IP addresses.
Instead for Subnets *Hosts-b* and *Hub* /23 because I need at least respectively 269 and 422 IP addresses.
For the Subnet C the choice is more easy because I have only 2 devices and then I use /30.

|  Subnet | Needed IPs| Available IPs   |
|---------|-----------|------------------|
| Hosts-a |    35     |  2^(32-26)-2=62 |            
| Hosts-b |    269    | 2^(32-23)-2=510 |            
| C       |     2     |  2^(32-30)-2=2  |            
| Hub     |    422    | 2^(32-23)-2=510 |

## VLANs
| Vlan ID | Subnet |
|---------|--------|
| 10  | Hosts-A      |
| 20  | Hosts-B      |

Two different VLANs allow router-1 to connect two different subnets via unique port. Thi two VLANs are marked with the ID above reported.

## Network Map 
```


        +-------------------------------------------------------------+
        |                                                             |
        |                                                             |enp0s3
        +--+--+                +------------+                  +------+-----+
        |     |                |            |7.7.30.1  7.7.30.2|            |
        |     |          enp0s3|            |enp0s9      enp0s9|            |
        |     +----------------+  router-1  +------------------+  router-2  |
        |     |                |            |                  |            |
        |     |                |            |                  |            |
        |  M  |                +-----+------+                  +------+-----+
        |  A  |             enp0s8.10|enp0s8.20                       |enp0s8
        |  N  |             7.7.10.62|7.7.20.254                      |7.7.40.254
        |  A  |                      |                                |
        |  G  |                      |                                |7.7.40.1
        |  E  |                      |                                |enp0s8
        |  M  |                      |enp0s8                    +-----+----+
        |  E  |            +---------+---------+                |          |
        |  N  |      enp0s3|                   |                |          |
        |  T  +------------+      SWITCH       |                |  host-c  |
        |     |            |                   |                |          |
        |     |            +-------------------+                |          |
        |  V  |               |enp0s9         |enp0s10          +-----+----+
        |  A  |               |               |                       |
        |  G  |               |7.7.10.1       |7.7.20.1               |
        |  R  |               |enp0s8         |enp0s8                 |
        |  A  |        +------+---+     +-----+----+                  |
        |  N  |        |          |     |          |                  |
        |  T  |  enp0s3|          |     |          |                  |
        |     +--------+  host-a  |     |  host-b  |                  |
        |     |        |          |     |          |                  |
        |     |        |          |     |          |                  |
        ++-+--+        +----------+     +----------+                  |
        | |                              |enp0s3                      |
        | |                              |                            |
        | +------------------------------+                            |
        |                                                             |
        |                                                             |
        +-------------------------------------------------------------+



```

## Changes at vagrantfile
I create  a .sh file for every device and next, I replace in Vagrantfile every general file with this more specific file.  
es. `common.sh` replaced with `host-1-a.sh`
```ruby
...
    router1.vm.provision "shell", path: "router-1.sh"
...
```
I increase the memory of virtual box of *host-c* from 256 to 512 to be able to host the Docker container.
```ruby
...
vb.memory = 512
```

## Host 1 A 
In `host-1-a.sh` with the following lines, I assign the IP address for interface *enp0s8* and set it up.
```py
ip link set dev enp0s8 up
ip addr add 7.7.10.1/26 dev enp0s8
```
Then, I define a static route to the Subnet *Hub*.
```ruby
ip route replace 7.7.40.0/23 via 7.7.10.62
```
## Host 1 B
This script use the same kids of commands of the previous.

## Host 2 C
The only differences of the *host-2-c* respect *host-1-a* and *host-1-b* is the presence of the Docker container that I implement this with the following lines:

```ruby
apt-get update -y
apt-get install -y tcpdump --assume-yes
apt-get install -y apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce --assume-yes --force-yes

docker pull -q dustnic82/nginx-test
docker run -d -p 80:80 dustnic82/nginx-test
```
And the static route towards *host-1-a* and *host-1-b*:
```ruby
ip route replace 7.7.10.0/26 via 7.7.40.254
ip route replace 7.7.20.0/23 via 7.7.40.254
```

## Router 1 
In `router-1.sh` with the following lines, I divide the router's interface enp0s8 into two subinterfaces, *enp0s8.10* and *enp0s8.20*, one for each VLAN.
```ruby
ip link add link enp0s8 name enp0s8.10 type vlan id 10
ip link add link enp0s8 name enp0s8.20 type vlan id 20
```
Then, I assign a IP address for each interface of *router-1* and set it up.
```ruby
ip link set dev enp0s8 up
ip link set dev enp0s8.10 up
ip link set dev enp0s8.20 up
ip addr add 7.7.10.62/26 dev enp0s8.10
ip addr add 7.7.20.254/23 dev enp0s8.20

ip link set dev enp0s9 up
ip addr add 7.7.30.1/30 dev enp0s9 
```

Finally,I enable the IP forwarding through IPv4, using the command `sysctl -w net.ipv4.ip_forward=1`.

## Router 2
This script use the same kids of commands of the previous.

## Switch
In `switch.sh` with the following lines, I create an virtual brige named switch and next I add the switch interfaces to the bridge as a trunk port.
```ruby
ovs-vsctl add-br switch
ovs-vsctl add-port switch enp0s8
ovs-vsctl add-port switch enp0s9 tag=10
ovs-vsctl add-port switch enp0s10 tag=20
```

Then, I set the three interfaces up.
```ruby
ip link set enp0s8 up
ip link set enp0s9 up
ip link set enp0s10 up
```

And finally, I set the system of the bridge up.
```ruby
ip link set dev ovs-system up
```
## Test
The following paragraphs report the commands and the tools to test that the network works correctly and respects every assignment specifications.

### How to start
Install Virtualbox and Vagrant

Clone the repository typing `git clone https://github.com/MattiaFerrari/dncs-lab`

Go to the cloned folder dncs-lab and launch the Vagrantfile:
```
~ [user_pc]$ cd dncs-lab
dncs-lab [user_pc]$ vagrant up
```

Log into the VMs with this command (es. *router-1*): `vagrant ssh router-1`

### ifconfig
This command, launched in each VM, is useful to verify the effective actualization of the configuration realized.
Es. the expected output for the *router-1* is:
```
vagrant@router-1:~$ ifconfig
enp0s3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
        inet6 fe80::83:96ff:fec1:64f9  prefixlen 64  scopeid 0x20<link>
        ether 02:83:96:c1:64:f9  txqueuelen 1000  (Ethernet)
        RX packets 1553  bytes 672876 (672.8 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 921  bytes 136540 (136.5 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

enp0s8: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet6 fe80::a00:27ff:fe56:ca41  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:56:ca:41  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 36  bytes 2808 (2.8 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

enp0s9: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 7.7.30.1  netmask 255.255.255.252  broadcast 0.0.0.0
        inet6 fe80::a00:27ff:fecd:9b3c  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:cd:9b:3c  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 12  bytes 936 (936.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

enp0s8.10: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 7.7.10.62  netmask 255.255.255.192  broadcast 0.0.0.0
        inet6 fe80::a00:27ff:fe56:ca41  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:56:ca:41  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 12  bytes 936 (936.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

enp0s8.20: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 7.7.20.254  netmask 255.255.254.0  broadcast 0.0.0.0
        inet6 fe80::a00:27ff:fe56:ca41  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:56:ca:41  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 12  bytes 936 (936.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 24  bytes 2096 (2.0 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 24  bytes 2096 (2.0 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

### ping
To check the correct connection of the devices and the reachability among the hosts, we used the command `ping`.

Es. If I consider *host-1-b* and *host-2-c*, the output should be similar to this:
```
vagrant@host-b:~$ ping 7.7.40.1
PING 7.7.40.1 (7.7.40.1) 56(84) bytes of data.
64 bytes from 7.7.40.1: icmp_seq=1 ttl=62 time=1.88 ms
64 bytes from 7.7.40.1: icmp_seq=2 ttl=62 time=1.56 ms
64 bytes from 7.7.40.1: icmp_seq=3 ttl=62 time=1.43 ms
64 bytes from 7.7.40.1: icmp_seq=4 ttl=62 time=1.39 ms
64 bytes from 7.7.40.1: icmp_seq=5 ttl=62 time=1.16 ms
64 bytes from 7.7.40.1: icmp_seq=6 ttl=62 time=1.42 ms
64 bytes from 7.7.40.1: icmp_seq=7 ttl=62 time=1.42 ms
64 bytes from 7.7.40.1: icmp_seq=8 ttl=62 time=1.57 ms
64 bytes from 7.7.40.1: icmp_seq=9 ttl=62 time=1.53 ms
^C
--- 7.7.40.1 ping statistics ---
9 packets transmitted, 9 received, 0% packet loss, time 8012ms
rtt min/avg/max/mdev = 1.164/1.487/1.881/0.181 ms
```

To test the effective isolation of the subnets with VLAN, I launch a ping command to the opposite Subnet address. I expect that the ping should not receive any reply.
```
vagrant@host-b:~$ ping 7.7.10.1
PING 7.7.10.1 (7.7.10.1) 56(84) bytes of data.

--- 7.7.10.1 ping statistics ---
9 packets transmitted, 0 received, 100% packet loss, time 8187ms
```
### route -n
The command route -n displays the routing tables of the routers.
Es. *router-1*
```
vagrant@router-1:~$ route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.0.2.2        0.0.0.0         UG    100    0        0 enp0s3
7.7.10.0        0.0.0.0         255.255.255.192 U     0      0        0 enp0s8.10
7.7.20.0        0.0.0.0         255.255.254.0   U     0      0        0 enp0s8.20
7.7.30.0        0.0.0.0         255.255.255.252 U     0      0        0 enp0s9
7.7.40.0        7.7.30.2        255.255.254.0   UG    0      0        0 enp0s9
10.0.2.0        0.0.0.0         255.255.255.0   U     0      0        0 enp0s3
10.0.2.2        0.0.0.0         255.255.255.255 UH    100    0        0 enp0s3
```

### curl
Finally, to verify that the *host-1-a* and the *host-1-b* can browse the website on *host-2-c*, I use the following command `curl 7.7.40.1` from *host-1-a* and *host-1-b*. I expect this output:
Es. *host-b*
```
vagrant@host-b:~$ curl 7.7.40.1
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

