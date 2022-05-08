# ubuntu 20.04
# k8s 1.23 (with kubeadm)
# cri: containerd
---
# install required dependencies for earch k8s server/node.
## enable some kernel modules and make them available now.
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
## create system network settings required for k8s to work properly and load them immediately.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.brige.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system
## install containerd.
sudo apt-get update
sudo apt-get install -y containerd
## create a default config file for containerd (on a directory) and restart containerd.
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
## install k8s required packages (first disable swap usage! check also /etc/fstab for swap usage)
sudo swapoff -a
sudo apt-get update
sudo apt-get install -y apt-transport-https curl
## install gpg key from k8s repo and enable the official k8s repo.
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
## install k8s 1.23 (kubeadm + kubectl) and prevent k8s to be updated when running 'sudo apt-get update'
sudo apt-get update
sudo apt-get install -y kubelet=1.23.0-00 kubeadm=1.23.0-00 kubectl=1.23.0-00
sudo apt-mark hold kubelet kubeadm kubectl
---
# initialize the cluster
## only on the control plane server/node!
sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.23.0
## set up kubeconfig to interact with the control plane node and get nodes
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl get nodes

# create the networking on the cluster (calico) and check control plane node status
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl get nodes

# join worker nodes to cluster
## copy the result from the command above and paste it onto the worker servers/nodes (example below) as sudo
kubeadm token create --print-join-command 
## after a few minutes nodes should show up as read:
kubectl get nodes
