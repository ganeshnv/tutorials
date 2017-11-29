Container:
----------
	Run in use space on top of the OS, OS level virutulazation system level,

	Support Same or similar OS (E.g) Centos OS have guest have centos or ubunut or susue or freeBSD

Application for containers:
---------------------------

	* OpenVZ
	* Solaris Zone
	* LXC
	* Docker

Docker:
------
	OpenSource engine that deployment containers by maintain of docker Inc,
	Easy to use and lightweight mode reality, 
	Logical Segration of duties, Fast efficient deployment life cycle, 
	encourage service oriented architecture.

Docker Component:
----------------

	* The Docker Cleint and Server
	* Docker Images 
	* Registres ( DockerHub) 
	* Docker Containers

Docker Containers:
------------------
	* Image Format 
	* set of standard operation 
	* execution environment
		Ship --> OS
		container --> Containerazation

Technical Component:
-------------------
	* plibcontainer --> LXC
	* Linux Kernel name space
	* FS isoloaton 
	* psudeo isolation 
	* resource isolation
	* network isolation 
	* copy on write -> layerd
	* Standard output => STDERR & STDIN
	* Interactive Shell => STDIN

Installation:
------------

## Requirements
	* 64 bit architecture
	* min Linux 3.8 kernel or later
	* kernel must support
		- Device Mapper
		- AUFS
		- UFS
		- BRTFS
		- Cgroup

check device mapper: 
	-> ls -l /sys/class/misc/device-mapper
	-> cat /proc/devices ==> device-mapper 

`` # yum install docker docker-swarm ``
`` # modprobe dm_mod `` 

ansible installation:
---------------------

`` github: git@github.com/azhaguprabu/tutorial/Docker/ansible ``
`` # ansible-playbook -i hosts docker.yml --diff ``

Docker Serivces:
---------------

`` # systemctl start docker ``
`` # systemctl enable docker ``	
	> Listen port 49155


Docker Basics:
--------------

# export DOCKER_HOST="tcp://0.0.0.0:3375"

Files:
	=> /etc/default/docker
	=> /etc/sysconfig/docker
	=> /usr/lib/systemd/docker-service --> ExecStart

**docker information**
 # docker info
 # docker version 

**To get the interactive ubuntu bash shell** 

  # docker run -i -t ubuntu:latest /bin/bash

  # docker ps -l

  # docker run --name con_name -i -t ubuntu /bin/bash

  # docker start con_name
 
  # docker stop con_name

  # docker rm con_name

  # docker attach con_name

Demanize Container:
-------------------

  # docker run --name daemon_container -d ubuntu /bin/bash -c "while true; do echo "hello world" ; sleep 1 ;done"

  # docker logs -f deamon_container

Inspect Container:
------------------

  # docker ps --format '{{ State.Running }}' daemon_container 

  # docker rm `docker ps -a -q`

**Docker images** => /var/lib/docker/<container_name>
 # yum images ls 

Docker Hub:
-----------
  # docker login
  # docker pull ubuntu:latest
  # docker search puppet 
  # docker pull username/imagename

Own Registery:
--------------
  
	* docker commit
	* docker build

Docker Commit:
-------------

  # docker run --name test_con -i -t ubuntu /bin/bash
  	> # apt-get -yqq apache2
  
  # docker commit test_con
 		or
  # docker commit -m "Updated ubuntu image" --author "Prabu" test_con

  # docker inspect test_con

Docker Build:
-------------

	``` version 1.0.1
	    FROM ubuntu:14.0.1
	    MAINTAINER prabu "azhagupabu"
	    RUN apt-get -yqq update
  	    RUN apt-get install nginx
	    RUN echo "HI I am container" > /usr/share/nginx/html/index.html
	    EXPOSE 80  ```

	without SHELL 

	   RUN [ 'apt-get', 'install', 'nginx' ]
     
  # docker build  -t username/web_con .
  
  GitHUB
  # docker build -t github@github/azhaguprabu/tutorial/docker

  --no-cache ==> it don't keep beging from layers 

  # docker history

  # docker run -d -p 80 --name static-web username/web_con nginx -g "daemon off;"

  # docker port static-web 80

+-----------------+-------------------------------------------------+
|  command        |    expose                                       |
+=================+=================================================+
|                 |   						    |
|   CMD           |  execute on lauch the container ( with arg )    |
|                 |  						    |
|   ENTRYPOINT    |  excute on deamon part ( without arg )          |
|                 | 						    |
|                 |   ENTRYPOINT [ /usr/bin/nginx ]                 |
|                 |   CMD [ -h ] 				    |
+-----------------+-------------------------------------------------+
|  USER           | 						    |
+-----------------+-------------------------------------------------+
|  ENV            |							
+-----------------+-------------------------------------------------
|  VOLUME         |
+-----------------+-------------------------------------------------
|  ADD            |
+-----------------+-------------------------------------------------
|  COPY           |
+-----------------+-------------------------------------------------
|  ONBUILD        |
+-----------------+-------------------------------------------------
|  EXPOSE	  |
+-----------------+-------------------------------------------------

**Docker images pull**
 # yum pull centos
 # yum pull centos:7.0

**Docker images list**
 # yum images ls

 # docker rmi usernaem/static_web


Local Registery:
---------------

  # docker run -p5000:5000 registry 

  # docker tag <container_ID> docker.example.com:5000/username/web_static

  # docker push docker.example.com:5000/username/web_static

  # docker run -i -t docker.example.com:5000/username/web_static /bin/bash

Linking:
-------

  # docker run -P 4657 --name webapp --link redis:db -t -i -v $(PWD):/opt/webapp username/web_static /bin/bash

privileged:
----------

  ** Run as root acess ** 

Backup from other container:
----------------------------

 # docker run --rm --volume-from web_con -v $PWD:/backup ubuntu tar -czf /backup/web_backup.tgz /var/www/html

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
