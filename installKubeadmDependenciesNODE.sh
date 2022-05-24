# ubuntu 20.04
# k8s 1.23 (with kubeadm)
# cri: Docker
# install required dependencies for earch k8s server/node.
## enable some kernel modules and make them available now.
sudo apt update && sudo apt upgrade && sudo apt autoremove

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
## install containerd and docker
sudo apt-get update

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo apt install openssh-server -y
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

