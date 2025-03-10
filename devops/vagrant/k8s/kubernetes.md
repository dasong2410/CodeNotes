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
  192.168.8.11 m-1
  192.168.8.21 w-1
  192.168.8.22 w-2
  ```

Prepare vms with vagrant, see [Vagrantfile](./Vagrantfile).

## 1. Installation

The [install.sh](./install.sh) script will install all the apps kubernetes needs.

Install kubernetes via kubeadm

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

## 2. Install container runtime

- https://kubernetes.io/docs/setup/production-environment/container-runtimes

### 2.1 Install containerd(if you use containerd as container runtime)

install.sh can do all the steps to install k8s, including configure system settings, install kubectl, kubeadm and kubelet.

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
# --pod-network-cidr=172.16.0.0/16
# kubeadm init \
# --apiserver-advertise-address=192.168.8.11 \
# --apiserver-cert-extra-sans=192.168.8.11 \
# --skip-phases=addon/kube-proxy

kubeadm init \
--apiserver-advertise-address=192.168.8.11 \
--apiserver-cert-extra-sans=192.168.8.11 \
--pod-network-cidr=172.16.0.0/16
```

```bash
root@m-1:~# kubeadm init \
--apiserver-advertise-address=192.168.8.11 \
--apiserver-cert-extra-sans=192.168.8.11 \
--pod-network-cidr=172.16.0.0/16
I0110 00:46:18.403812    9909 version.go:256] remote version is much newer: v1.32.0; falling back to: stable-1.29
[init] Using Kubernetes version: v1.29.12
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local m-1] and IPs [10.96.0.1 192.168.8.11]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [localhost m-1] and IPs [192.168.8.11 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [localhost m-1] and IPs [192.168.8.11 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "super-admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[apiclient] All control plane components are healthy after 6.507176 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node m-1 as control-plane by adding the labels: [node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
[mark-control-plane] Marking the node m-1 as control-plane by adding the taints [node-role.kubernetes.io/control-plane:NoSchedule]
[bootstrap-token] Using token: s7auz9.yfcduie24hijxvmo
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

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

kubeadm join 192.168.8.11:6443 --token s7auz9.yfcduie24hijxvmo \
	--discovery-token-ca-cert-hash sha256:1392a807008f43c3e64144638ec31afe7bbd59d1d63bd0f7bf6512c200556ca0
root@m-1:~#
```

### 3.2 Setup environments

To start using your cluster, you need to run the following as a regular user:

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

```bash
# create aliases
cat >> ~/.bash_aliases <<EOF
alias k='kubectl'
alias ks='kubectl -n kube-system'
EOF
```

### 3.3 Network addon(on primary node)

install after init

https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/

```bash
#kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml


cilium install
```

### 3.4 Join to cluster(on all secondary nodes)

```bash
kubeadm join 192.168.8.11:6443 --token s7auz9.yfcduie24hijxvmo \
	--discovery-token-ca-cert-hash sha256:1392a807008f43c3e64144638ec31afe7bbd59d1d63bd0f7bf6512c200556ca0
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
# /etc/containerd/config.toml
# SystemdCgroup = true

sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

sudo systemctl restart containerd
```

```bash
sudo sed -i 's#registry.k8s.io/pause:3.8#registry.k8s.io/pause:3.9#g' /etc/containerd/config.toml

sudo systemctl restart containerd
```

### 99.5 error: unable to upgrade connection: pod does not exist

https://stackoverflow.com/questions/51154911/kubectl-exec-results-in-error-unable-to-upgrade-connection-pod-does-not-exi

```bash
# /etc/default/kubelet
KUBELET_EXTRA_ARGS="--node-ip=192.168.8.11"
KUBELET_EXTRA_ARGS="--node-ip=192.168.8.21"
KUBELET_EXTRA_ARGS="--node-ip=192.168.8.22"
```

Then, restart k8s cluster.
