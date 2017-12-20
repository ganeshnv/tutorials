# Docker Network 

Namespaces are a feature of the Linux Kernel that isolate and virtualize system resource of a collection of processes. Virtualized include 

	* Process ID
	* Hostname
	* user ID's
	* Netowrk Access
	* Interprocess Communications
	* filesystem
 
 Here I am going explain the Network Access Namespace.

### Docker Backend process to create the container with Networking

	* Create container with unique Namespace you can identify the following command
	* Create the veth patch interface one end connect with Bridge ( default ) other end create namespace interface of the container.
	* you can manually see the namespace and see the ip address 

	~~~ # docker inspect <ContainerID> |grep Pid
	    # mkdir /var/run/netns
	    # ln -sf /proc/<Pid>/ns/net /var/run/netns/<container UUID | container ID >
	    # ip netns list
	    # ip netns exec <Container UUID | ID > ip addr
	~~~

## Connect container with specific Network 

	``` # docker network connect <networkName | ID> <Container ID | Name> ```

## Disconnect the container from th network

	``` # docker network disconnect <network Name | ID> <Container ID | Name> ```

### Create Nework Namespace (NS)

	``` # ip netns add my-netns ```

### Create the veth patch virtual cable interface 
	
	``` # ip link add veth0 type veth peer name veth1 ```

### Assign one end to Docker bridge 
	
	``` # ip link set veth0 master docker0 ```

### Assing other end into my-newns 

	``` # ip link set eth1 netns my-netns ```

### Assign the ip address & gateway to the network 

	``` # ip netns exec my-netns ip addr add 172.17.0.2/24
	    # ip netns exec my-netns ip route add default via 172.17.0.1 ```
	
### up both end interfaces
	   
	``` # ip netns exec my-netns ip link set veth1 up ```

	``` # ip link set veth0 up ```

### Test the connection 

	``` # ip netns exec my-net ping 172.17.0.1 ``` 


## Types of Docker Network
	
	* None
	* Host
	* Bridge
	* Overlay
	* Container

### Notes:

 Disalbe inter container communications

	``` # docker network create --driver bridge -o "com.docker.network.bridge.enable_icc"="false" \
			--subnet=172.16.0.0/16 --ip-range=172.16.1.0/24 --gateway=172.16.1.1 bridge0 ```

 Create the overlay Network

	``` # docker network create -d overlay --subnet=192.168.0.0/16 --subnet=192.17.0.0/16 \
			--gateway=192.168.0.1 --gateway=192.17.0.1 --ip-range=192.17.0.0      \
			--aux-address='my-router1=192.17.0.1' --aux-address='my-router2=192.17.0.254" \
			-d overlay my-multinetwork ```

 Low Latency Application on Host Network 

	``` # docker run --name voip -d -p 10000-20000:10000-20000/udp -p 5060:5060/udp --network host asterisk-voip ```
