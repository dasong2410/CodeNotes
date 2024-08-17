# Kubernetes

- kubelet can't be run when swap is on, so need to disable it on all nodes.

  ```bash
  sudo swapoff -a
  ```

- check log
  ```bash
  /var/log/containers

  journalctl -xn -u kubelet
  ```
- reset
  ```bash
  kubeadm reset
  ```
- nodes
  ```bash
  192.168.56.13 node-1
  192.168.56.14 node-2
  192.168.56.15 node-3
  ```

Prepare vms with vagrant, see [Vagrantfile](vagrant/k8s/Vagrantfile).

## 1. Installation

Install kubernetes via kubeadm

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

## 2. Install container runtime

- https://kubernetes.io/docs/setup/production-environment/container-runtimes

### 2.1 Install containerd(if you use containerd as container runtime)

Kubernetes cluster still can't work normally even after successfully installed.

- https://github.com/containerd/containerd/blob/main/docs/getting-started.md
- https://docs.docker.com/engine/install/ubuntu/

  ```bash
  # don't forget to do preview steps
  sudo apt-get install containerd.io
  ```

- https://kubernetes.io/docs/tasks/administer-cluster/migrating-from-dockershim/change-runtime-containerd/#install-containerd

  ```bash
  sudo mkdir -p /etc/containerd
  containerd config default | sudo tee /etc/containerd/config.toml

  # Must change SystemdCgroup to true, otherwise kubelet will randomly shutdown etcd
  SystemdCgroup = true

  sudo systemctl restart containerd
  ```



### 2.2 Install cri-dockerd(if you use docker engin as container runtime)

If you want to use docker engin as container runtime, you should install cri-dockerd since kubenetes deprecated dockershim.

#### 2.2.1 Install docker

https://docs.docker.com/engine/install/ubuntu/

#### 2.2.2 Install cri-dockerd

https://github.com/Mirantis/cri-dockerd

```bash
sudo su -

wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.1/cri-dockerd_0.3.1.3-0.ubuntu-bionic_amd64.deb

sudo dpkg -i cri-dockerd_0.3.1.3-0.ubuntu-bionic_amd64.deb
```

## 3. Create cluster

- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
- https://kubernetes.io/docs/concepts/cluster-administration/networking/#how-to-implement-the-kubernetes-networking-model
- https://www.weave.works/docs/net/latest/kubernetes/kube-addon/

### 3.1 Init(on primary node)

```bash
kubeadm init \
--apiserver-advertise-address=192.168.56.13 \
--apiserver-cert-extra-sans=192.168.56.13 \
--pod-network-cidr=172.16.0.0/16
```

```bash
root@node-1:~# kubeadm init \
--apiserver-advertise-address=192.168.56.13 \
--apiserver-cert-extra-sans=192.168.56.13 \
--pod-network-cidr=172.16.0.0/16

.
.
.

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.56.13:6443 --token zmxv7q.66z4glut5olwjssm \
	--discovery-token-ca-cert-hash sha256:ee8f743afb83d2ab20c9e8319bda48dbe216eb18dc73d9c8d0f1aaed11612233
root@node-1:~#
```

### setup environments

To start using your cluster, you need to run the following as a regular user:

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### network addon(on primary node)

install after init

https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/

```bash
#kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml


cilium install
```

### Join to cluster(on all secondary nodes)

```bash
kubeadm join 192.168.56.13:6443 --token zmxv7q.66z4glut5olwjssm \
	--discovery-token-ca-cert-hash sha256:ee8f743afb83d2ab20c9e8319bda48dbe216eb18dc73d9c8d0f1aaed11612233
```

## 99. Troubleshooting

### 99.1 couldn't get current server API group list: connection refused

https://k21academy.com/docker-kubernetes/the-connection-to-the-server-localhost8080-was-refused/

```bash
root@node-1:~# kubectl get nodes
E0322 01:55:58.791703  123613 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
E0322 01:55:58.794645  123613 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
E0322 01:55:58.798098  123613 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
E0322 01:55:58.799086  123613 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
E0322 01:55:58.800063  123613 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
The connection to the server localhost:8080 was refused - did you specify the right host or port?
```

fix: setup environment varibales

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### 99.2 couldn't get current server API group list, certificate signed by unknown authority

```bash
vagrant@node-1:~$ kubectl get nodes
E0323 02:28:56.387188   14723 memcache.go:265] couldn't get current server API group list: Get "https://192.168.56.4:6443/api?timeout=32s": x509: certificate signed by unknown authority (possibly because of "crypto/rsa: verification error" while trying to verify candidate authority certificate "kubernetes")
E0323 02:28:56.392205   14723 memcache.go:265] couldn't get current server API group list: Get "https://192.168.56.4:6443/api?timeout=32s": x509: certificate signed by unknown authority (possibly because of "crypto/rsa: verification error" while trying to verify candidate authority certificate "kubernetes")
E0323 02:28:56.397655   14723 memcache.go:265] couldn't get current server API group list: Get "https://192.168.56.4:6443/api?timeout=32s": x509: certificate signed by unknown authority (possibly because of "crypto/rsa: verification error" while trying to verify candidate authority certificate "kubernetes")
E0323 02:28:56.403275   14723 memcache.go:265] couldn't get current server API group list: Get "https://192.168.56.4:6443/api?timeout=32s": x509: certificate signed by unknown authority (possibly because of "crypto/rsa: verification error" while trying to verify candidate authority certificate "kubernetes")
E0323 02:28:56.409432   14723 memcache.go:265] couldn't get current server API group list: Get "https://192.168.56.4:6443/api?timeout=32s": x509: certificate signed by unknown authority (possibly because of "crypto/rsa: verification error" while trying to verify candidate authority certificate "kubernetes")
Unable to connect to the server: x509: certificate signed by unknown authority (possibly because of "crypto/rsa: verification error" while trying to verify candidate authority certificate "kubernetes")
```

fix: remove $HOME/.kube, copy it again

```bash
rm -rf $HOME/.kube

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### 99.3 ERROR FileContent--proc-sys-net-ipv4-ip_forward

when using containerd as runtime, init will raise following error

```bash
[preflight] Running pre-flight checks
error execution phase preflight: [preflight] Some fatal errors occurred:
	[ERROR FileContent--proc-sys-net-bridge-bridge-nf-call-iptables]: /proc/sys/net/bridge/bridge-nf-call-iptables does not exist
	[ERROR FileContent--proc-sys-net-ipv4-ip_forward]: /proc/sys/net/ipv4/ip_forward contents are not set to 1
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
To see the stack trace of this error execute with --v=5 or higher
root@node-1:~#
```

fix: modprobe

https://github.com/kubernetes/kubeadm/issues/1062

```bash
modprobe br_netfilter
echo '1' > /proc/sys/net/ipv4/ip_forward
```

### 99.4 etcd keeps shutting down randomly on new self-managed k8s cluster via kubeadm

https://github.com/etcd-io/etcd/issues/13670

```bash
/etc/containerd/config.toml
SystemdCgroup = true

sudo systemctl restart containerd
```
