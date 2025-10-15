# Kubernetes Test Environment

- Prepare vms
- Install kubernetes
- Prepare kubernetes pv/pvc
- Install Percona-Postgre-Operator

### Prepare vms

```bash
# Create/Start vms
vagrant up

# Shutdown vms
vagrant halt

# Delete vms
vagrant destroy -f
```

### Create lvs

```bash
sudo pvcreate /dev/sda3
sudo pvdisplay

sudo vgcreate vg_iscsi /dev/sda3

sudo vgdisplay
sudo lvcreate -L 5G -n iscsi_disk01 vg_iscsi
sudo lvcreate -L 5G -n iscsi_disk02 vg_iscsi
sudo lvcreate -L 5G -n iscsi_disk03 vg_iscsi
sudo lvcreate -L 5G -n iscsi_disk04 vg_iscsi
sudo lvcreate -L 5G -n iscsi_disk05 vg_iscsi

sudo lvdisplay
sudo mkfs.ext4 /dev/vg_iscsi/iscsi_disk01
sudo mkfs.ext4 /dev/vg_iscsi/iscsi_disk02
sudo mkfs.ext4 /dev/vg_iscsi/iscsi_disk03
sudo mkfs.ext4 /dev/vg_iscsi/iscsi_disk04
sudo mkfs.ext4 /dev/vg_iscsi/iscsi_disk05
```

### Create shared disks

Copy iscsi/*.conf to /etc/tgt/conf.d

- https://www.server-world.info/en/note?os=Ubuntu_24.04&p=iscsi&f=2
- https://www.server-world.info/en/note?os=Ubuntu_22.04&p=iscsi&f=3
- https://docs.openshift.com/container-platform/3.11/install_config/persistent_storage/persistent_storage_iscsi.html





```bash
ctr -n k8s.io containers list
ctr ns ls

ctr run <imageName> <uniqueValue>

ctr run  kube-apiserver:v1.30.2 33a54fabc899eb15935ee1b72f6b530be736021e97a25e9fd0c600609e68934e
```

https://stackoverflow.com/questions/47128586/how-to-delete-all-resources-from-kubernetes-one-time

```bash
kubectl get pods --all-namespaces -o wide
kubectl describe pod kube-proxy-qmxqq -n kube-system
```

```bash
sudo iscsiadm -m discovery -t sendtargets -p 192.168.56.1
sudo iscsiadm -m node --login
sudo iscsiadm -m session -o show
sudo cat /proc/partitions


sudo parted --script /dev/sdb "mklabel gpt"
sudo parted --script /dev/sdb "mkpart primary 0% 100%"
sudo mkfs.ext4 /dev/sdb1

sudo parted --script /dev/sdc "mklabel gpt"
sudo parted --script /dev/sdc "mkpart primary 0% 100%"
sudo mkfs.ext4 /dev/sdc1

sudo parted --script /dev/sdd "mklabel gpt"
sudo parted --script /dev/sdd "mkpart primary 0% 100%"
sudo mkfs.ext4 /dev/sdd1

sudo parted --script /dev/sde "mklabel gpt"
sudo parted --script /dev/sde "mkpart primary 0% 100%"
sudo mkfs.ext4 /dev/sde1



kubectl delete namespace postgres-operator
kubectl create namespace postgres-operator


curl -k -H "Content-Type: application/json" -X PUT --data-binary @tmp.json http://127.0.0.1:8001/api/v1/namespaces/postgres-operator/finalize
```
