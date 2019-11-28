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


I choose for Subnet Hosts-A /26 because I need at least 35 IP addresses. (2^(32-26)-2=62)
Instead for Subnets Hosts-b and Hub /23 because I need at least respectively 269 and 422 IP addresses. (2^(32-23)-2=510)
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

Two different VLANs allow router-1 to connect two different subnets via unique port. Thi two VLANs are marked with the ID above reported

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
I increase the memory of virtual box of *host-c* from 256 to 512
```ruby
...
vb.memory = 512
```

## Host 1 A 
In `host-1-a.sh` with the following lines, I assign the IP address for interface *enp0s8* and set it up
```ruby
ip link set dev enp0s8 up
ip addr add 7.7.10.1/26 dev enp0s8
```
Then, I define a static route to the Subnet *Hub* 
```ruby
ip route replace 7.7.40.0/23 via 7.7.10.62
```
## Host 1 B
This script use the same kids of commands of the previous.

## Host 2 C
The only difference of the *Host-2-C* respect *Host-1-A* and *Host-1-B* is the presence of the Docker container.
I implement this with the following lines:

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

## Router 1 
In `router-1.sh` with the following lines, I divide the router's interface enp0s8 into two subinterfaces, *enp0s8.10* and *enp0s8.20*, one for each VLAN. (...)
```
ip link add link enp0s8 name enp0s8.10 type vlan id 10
ip link add link enp0s8 name enp0s8.20 type vlan id 20
```
Then, I assign a IP address for each interface of *router-1* and set it up
```
ip link set dev enp0s8 up
ip link set dev enp0s8.10 up
ip link set dev enp0s8.20 up
ip addr add 7.7.10.62/26 dev enp0s8.10
ip addr add 7.7.20.254/23 dev enp0s8.20

ip link set dev enp0s9 up
ip addr add 7.7.30.1/30 dev enp0s9 
```

Finally,I enable the IP forwarding through IPv4, using the command `sysctl -w net.ipv4.ip_forward=1`

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
```
ip link set enp0s8 up
ip link set enp0s9 up
ip link set enp0s10 up
```

And finally, I set the system of the bridge up.
```
ip link set dev ovs-system up
```
## Test

