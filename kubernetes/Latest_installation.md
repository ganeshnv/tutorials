# Kubenetes Documents

## Cluster installtion
### Master setup

	Comment the swap partition /etc/fstab
	swapoff -a
	yum install docker -y
 	systemctl enable docker && systemctl start docker 

	cat <<EOF >  /etc/sysctl.d/k8s.conf
	net.bridge.bridge-nf-call-ip6tables = 1
	net.bridge.bridge-nf-call-iptables = 1
	EOF
	sysctl --system

	cat <<EOF > /etc/yum.repos.d/kubernetes.repo
	[kubernetes]
	name=Kubernetes
	baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
	enabled=1
	gpgcheck=1
	repo_gpgcheck=1
	gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
	exclude=kube*
	EOF
	setenforce 0
	yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

	vim /etc/default/kubectl
	KUBELET_KUBEADM_EXTRA_ARGS= “—cgroup-driver=systemd”	
	
vim /etc/sysconfig/kubelet
	KUBELET_EXTRA_ARGS="--runtime-cgroups=/systemd/system.slice --kubelet-cgroups=/systemd/system.slice"

	 systemctl daemon-reload
	systemctl restart kubelet
	systemctl enable kubelet

	kubeadm init 	

	
	firewall-cmd  --permanent --add-port=6443/tcp
	firewall-cmd  --permanent --add-port=10250/tcp
	firewall-cmd  --permanent --add-port=2379-2380/tcp
	firewall-cmd  --permanent --add-port=10251/tcp
	firewall-cmd  --permanent --add-port=10252/tcp
	
	kubeadm config images pull

	kubeadm init

	<< Note the kubeadm join command >>

	mkdir -p $HOME/.kube
	sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	sudo chown $(id -u):$(id -g) $HOME/.kube/config
	kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"


### Nodes setup:

	Follow upto kubelet installation ( kubectl no need for nodes ) 
	Then execute $kubeadm join command 
	#systemctl enable kubelet && systemctl start kubelet
	firewall-cmd --permanent --add-port=10250/tcp
	firewall-cmd --permanent --add-port=30000-32767/tcp

### Master 

	kubeadm get nodes
	kubeadm apply -f https://k8s.io/examples/application/deployment.yaml
	kubeadm get pods
	kubeadm describe pods
	kubeadm describe deployment < nginx-deployment >
	kubectl get pods -l app=nginx
	kubectl delete deployment nginx-deployment

Schedule pods on the master:
	#kubectl taint nodes --all node-role.kubernetes.io/master-

Connect Kubernet outside network:
	scp root@<master ip>:/etc/kubernetes/admin.conf .
	kubectl --kubeconfig ./admin.conf proxy
	http://localhost:6443/api/v1

Kind	:
	- pod
	- service
	- replicateSet
	- deployment
	- configMap
	- Role
	- ClusterRole
 	- RoleBinding
	- ClusterRoleBinding
	- DaemonSet

CNI:
 Flannel:
	#kubeadm iniit --pod-network-cidr=10.244.0.0/26 
	echo 1 > /proc/sys/net/brdige/brdige-nf-call-iptables 
	sysctl net.brdige.birdge-nf-call-iptables=1
	
	#kubectl --aply -f https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml

Weave Net:
	echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
	sysctl net.bridge.bridge-nf-call-iptables=1
	kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

Calico ( work only amd64 )
	kubeadm init --pod-network-cidr=192.168.10.0/24
	kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
	kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml

Nginx Pod Yaml: pod.yaml

---	
apiVersion: v1
kind: pod
metadata:
	name: nginx
	labels:
		app: nginx
spec:
	containers:
		image: nginx:1.10.0

#kubectl apply -f pod.yaml
#kubectl get pods —all-namespaces
#kubectl get pods —output=yaml

Tear down the Node ( empty the node config and remove ) 
	# kubectl drain <node name> —delete-local-data —force --ignore-daemonsets
	# kubectl delete node <node name>
	
	remove on the nodes :
	#kubeadm reset
