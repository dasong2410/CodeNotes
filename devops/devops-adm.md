kubectl get pods -n kube-system

kubectl exec etcd-master -n kube-system etcdctl get / --prefix -keys-only


kubectl exec etcd-master -n kube-system etcdctl get / --prefix -keys-only