Kobernets
---------

Descriptoin of setup:
master:
 host: k8s-master.example.com
 IP: 192.168.0.20

node1:
 host: k8s-node1.example.com
 IP: 192.168.0.21

1. # comment the swap patition in /etc/fstab
2. swapoff -a
3. # disable the selinux /etc/selinux/config
4. setenforce 0
5. yum install -y docker
6. systemctl enable docker && systemctl start docker
7. cat <<EOF > /etc/yum.repos.d/kubernetes.repo
	[kubernetes]
	name=Kubernetes
	baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
	enabled=1
	gpgcheck=1
	repo_gpgcheck=1
	gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
	exclude=kube*
	EOF
8. yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
9. systemctl enable kubelet && systemctl start kubelet
10. cat <<EOF >  /etc/sysctl.d/k8s.conf
	net.bridge.bridge-nf-call-ip6tables = 1
	net.bridge.bridge-nf-call-iptables = 1
	EOF
11. sysctl --system
12. kubeadm init --apiserver-advertisement-ip=192.168.0.20 --pod-network-cidr=10.0.0.0/16
13. # note the kubeadm join command

Join the Nodes.
1. # Follow master installation 1-9
2. # Execute the kubeadm join command 

Verify the instllation k8s-master
1. kubectl --kubeconfig /etc/kubernetes/admin.conf get nodes
2. kubectl --kubeconfig /etc/kubernets/admin.conf get pods
3. kubectl --kubeconfig /etc/kubeernets/admin.conf get pods --all-namespaces

Deployment:

1. kubectl --kubeconfig /etc/kubernetes/admin.conf create deployment nginx --image=nginx
2. kubectl --kubeconfig /etc/kubeernets/admin.conf describe deployment nginx
3. kubectl --kubeconfig /etc/kubernetes/admin.conf create service nodeport nginx --tcp=80:80
4. kubectl --kubeconfig /etc/kubernetes/admin.conf get nodes
5. kubectl --kubeconfig /etc/kubernets/admin.conf get pods
6. # Note the port mapped

Verify Deployment:
1. crul k8s-node1:<mapped port noted from  pods>
