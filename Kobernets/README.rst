Kobernets
---------
*Descriptoin of setup*
``master:
 host: k8s-master.example.com
 IP: 192.168.0.20

node1:
 host: k8s-node1.example.com
 IP: 192.168.0.21``

Installation:
------------
- # comment the swap patition in /etc/fstab
- swapoff -a
- # disable the selinux /etc/selinux/config
- setenforce 0
- yum install -y docker
- systemctl enable docker && systemctl start docker
- cat <<EOF > /etc/yum.repos.d/kubernetes.repo
	[kubernetes]
	name=Kubernetes
	baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
	enabled=1
	gpgcheck=1
	repo_gpgcheck=1
	gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
	exclude=kube*
	EOF
- yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
- systemctl enable kubelet && systemctl start kubelet
- cat <<EOF >  /etc/sysctl.d/k8s.conf
	net.bridge.bridge-nf-call-ip6tables = 1
	net.bridge.bridge-nf-call-iptables = 1
	EOF
- sysctl --system
- kubeadm init --apiserver-advertisement-ip=192.168.0.20 --pod-network-cidr=10.0.0.0/16
- # note the kubeadm join command

Join the Nodes
--------------
- # Follow master installation 1-9
- # Execute the kubeadm join command 

Verify the instllation k8s-master:
----------------------------------
- kubectl --kubeconfig /etc/kubernetes/admin.conf get nodes
- kubectl --kubeconfig /etc/kubernets/admin.conf get pods
- kubectl --kubeconfig /etc/kubeernets/admin.conf get pods --all-namespaces

Deployment:
-----------
- kubectl --kubeconfig /etc/kubernetes/admin.conf create deployment nginx --image=nginx
- kubectl --kubeconfig /etc/kubeernets/admin.conf describe deployment nginx
- kubectl --kubeconfig /etc/kubernetes/admin.conf create service nodeport nginx --tcp=80:80
- kubectl --kubeconfig /etc/kubernetes/admin.conf get nodes
- kubectl --kubeconfig /etc/kubernets/admin.conf get pods
- # Note the port mapped

Verify Deployment:
------------------
- crul k8s-node1:<mapped port noted from  pods>
