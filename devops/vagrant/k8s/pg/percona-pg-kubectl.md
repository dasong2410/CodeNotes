## Percona Operator for PostgreSQL

### Create lv

```bash
lvcreate -n k8s_disk01 -L 5G ubuntu-vg
lvcreate -n k8s_disk02 -L 5G ubuntu-vg
lvcreate -n k8s_disk03 -L 5G ubuntu-vg
lvcreate -n k8s_disk04 -L 5G ubuntu-vg
```


### Install Percona Distribution for PostgreSQL using kubectl

- https://docs.percona.com/percona-operator-for-postgresql/2.0/kubectl.html


### Connect to the PostgreSQL cluster
- https://docs.percona.com/percona-operator-for-postgresql/2.0/kubectl.html
- https://docs.percona.com/percona-operator-for-postgresql/2.0/TLS.html
- https://docs.percona.com/percona-operator-for-postgresql/2.0/connect.html
- https://forums.percona.com/t/pgbouncer-not-finding-cluster1-primary/24940
- https://forums.percona.com/t/pgbouncer-server-dns-lookup-failed/19731
- https://medium.com/@amirhosseineidy/how-to-join-master-node-or-control-plane-to-kubernetes-cluster-e16be68459bf

```bash
PGBOUNCER_URI=$(kubectl get secret cluster1-pguser-cluster1 --namespace postgres-operator -o jsonpath='{.data.pgbouncer-uri}' | base64 --decode)
kubectl run -i --rm --tty pg-client --image=perconalab/percona-distribution-postgresql:17 --restart=Never -- psql $PGBOUNCER_URI

kubectl exec -it -n postgres-operator cluster1-instance1-dqlw-0 -- /bin/bash
```

### Delete Percona Operator for PostgreSQL

- https://docs.percona.com/percona-operator-for-postgresql/2.0/delete.html

- https://medium.com/@haroldfinch01/how-to-delete-all-resources-from-kubernetes-one-time-a447ae08ffd8

```bash
kubectl delete all --all -n postgres-operator

# change finalizers to finalizers: []
kubectl edit crd xxx
```
