#!bin/bash

### Update packages and disbale swap
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

### Set Up echo Add  iptables
sudo cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
modprobe br_netfilter
sysctl -p /etc/sysctl.conf

### Download Containerd Binaries 
### Check Release: [containerd](https://github.com/containerd/containerd/releases/)
sudo wget https://github.com/containerd/containerd/releases/download/v1.7.13/containerd-1.7.13-linux-amd64.tar.gz
sudo tar Cxzvf /usr/local containerd-1.7.13-linux-amd64.tar.gz
sudo rm -rf containerd-1.7.13-linux-amd64.tar.gz

## Setup container and restart Containerd
wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mkdir -p /usr/local/lib/systemd/system
sudo mv containerd.service /usr/local/lib/systemd/system/containerd.service
sudo systemctl daemon-reload
sudo systemctl enable --now containerd

### Install Runtime Class
### Check Release: [runc](https://github.com/opencontainers/runc/releases/)
wget https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64
sudo install -m 755 runc.amd64 /usr/local/sbin/runc

### Insttall CNI plugins
### Check Release: [CNI Plugin](https://github.com/containernetworking/plugins/releases/)
sudo mkdir -p /opt/cni/bin
wget https://github.com/containernetworking/plugins/releases/download/v1.4.0/cni-plugins-linux-amd64-v1.4.0.tgz
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.4.0.tgz
sudo rm -rf cni-plugins-linux-amd64-v1.4.0.tgz



### Install CRITCL
### Check Release: [CNI Plugin](https://github.com/kubernetes-sigs/cri-tools/releases)
VERSION="v1.26.0"
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz

sudo touch /etc/crictl.yaml
sudo cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 2
debug: false
pull-image-on-create: false
EOF

### Install kubectl, kubelet and kubeadm
sudo mkdir /etc/apt/keyrings

sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

### Update packages and disable swap
sudo apt-get update -y || { echo "apt-get update failed"; exit 1; }

### Wait for 30 seconds before retrying apt-get update
echo "Waiting for 30 seconds before retrying apt-get update..."
sleep 30

### Attempt to run apt-get update again
sudo apt-get update -y || { echo "apt-get update failed"; exit 1; }

### Install k8s binaries
# sudo apt -y install kubelet=1.28.7-1.1  kubeadm=1.28.7-1.1 kubectl=1.28.7-1.1
sudo apt -y install kubelet kubeadm kubectl

sudo apt-mark hold kubelet kubeadm kubectl 
