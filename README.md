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
|---------|---------- |-----------------|
| Hosts-a |    35     |  2^(32-26)-2=62 |            
| Hosts-b |    269    | 2^(32-23)-2=510 |            
| C       |     2     |  2^(32-30)-2=2  |            
| Hub     |    422    | 2^(32-23)-2=510 |            

## VLANs
| VID | Subnet |
|-----|--------|
| 10  | Host A      |
| 20  | Host B      |

Two different VLANs allow router-1 to connect two different subnets via unique port. Thi two VLANs are marked with the VIDs above reported

## Changes at vagrantfile
I create  a .sh file for every device and next, I replace in Vagrantfile every general file with this more specific file.  
es. `common.sh` replaced with `host-1-a.sh`
```ruby
...
    router1.vm.provision "shell", path: "router-1.sh"
...
```
I increase the memory of virtual box of host-c from 256 to 512

## Host 1 A 
In host-1-a.sh I add the following line for the general setup of the host
```ruby
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump --assume-yes
apt install -y curl --assume-yes
```
Then, In host-1-a.sh with the following lines, I assign the IP address for interface eth1 and set it up
```ruby
ip addr add 7.7.10.1/30 dev eth1
ip link set dev eth1 up
```
## Host 1 B
In `host-1-b.sh` with the following lines, I do the general setup of the host
```ruby
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump --assume-yes
apt install -y curl --assume-yes
```
Then, `In host-1-b.sh` with the following lines, I assign the IP address for interface eth1 and set it up
```ruby
ip addr add 7.7.20.1/23 dev eth1
ip link set dev eth1 up
```

## Router 1 

## Switch - COMPLETE
In `switch.sh` with the following lines, I create a virtual switch and next I add the ports to the switch.
```ruby
ovs-vsctl add-br switch
ovs-vsctl add-port switch eth1
ovs-vsctl add-port switch eth2 tag=10
ovs-vsctl add-port switch eth3 tag=20
```

Then, I set the three interfaces up
```
ip link set eth1 up
ip link set eth2 up
ip link set eth3 up
```

And finally, I set the switch up
```
ip link set dev ovs-system up
```
## Router 2

## Host 2 C

## Test

