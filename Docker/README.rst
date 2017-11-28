Installation:
------------
`` # yum install docker docker-swarm ``

ansible installation:
---------------------

`` github: git@github.com/azhaguprabu/tutorial/Docker/ansible ``
`` # ansible-playbook -i hosts docker.yml --diff ``

Docker Basics:
--------------

**docker information**
 # docker info
 # docker version 

**Docker images**
 # yum images ls 

**Docker images pull**
 # yum pull centos
 # yum pull centos:7.0

**Docker images list**
 # yum images ls

Swarm:
------

Post Listen: tcp/2377, tcp/4789, tcp/7946

**init the swarm connection**
 # docker swarm init --advertise-addr <Ip-address>

**Join the nodes**
 # docker swarm join --token <token ID> <Master IP>:2377

**list swarm nodes**
 # docker node ls

**create the service**
 # docker service create --name ping00 --replicas 5 alphine ping masterIP

**List the serivce**
 # docker service ls

**list service tasks**
 # docker service task ping00

**update replicas**
 # docker service update --replicas 10 ping00

**leave nodes from swarm**
 # docker swarm leave

**remove list from nodes**
 # docker swarm rm <node>
