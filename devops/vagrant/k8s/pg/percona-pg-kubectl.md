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
kubectl apply -n postgres-operator -f pg-client.yml

kubectl exec -n postgres-operator deployment/pg-client -it -- bash -il


kubectl exec -n postgres-operator pod/cluster1-instance1-8wvk-0 -it -- bash -il
```

```bash
# get secret
PGBOUNCER_URI=$(kubectl get secret cluster1-pguser-cluster1 --namespace postgres-operator -o jsonpath='{.data.pgbouncer-uri}' | base64 --decode)

# error
# psql: error: connection to server at "cluster1-pgbouncer.postgres-operator.svc" (10.100.46.231), port 5432 failed: FATAL:  query_wait_timeout
PGSSLMODE=verify-ca PGSSLROOTCERT=/tmp/tls/ca.crt psql postgresql://cluster1:%3AmaCAGEA%2F%2A._L%7Cj-Vm%2A%5BVjaH@cluster1-pgbouncer.postgres-operator.svc:5432/cluster1

# working properly
psql postgresql://cluster1:%3AmaCAGEA%2F%2A._L%7Cj-Vm%2A%5BVjaH@cluster1-ha.postgres-operator.svc:5432/cluster1


psql postgresql://cluster1:%3AmaCAGEA%2F%2A._L%7Cj-Vm%2A%5BVjaH@cluster1-primary.postgres-operator.svc:5432/cluster1
psql postgresql://cluster1:%3AmaCAGEA%2F%2A._L%7Cj-Vm%2A%5BVjaH@cluster1-replicas.postgres-operator.svc:5432/cluster1

cluster1-primary
```


### Delete Percona Operator for PostgreSQL

- https://docs.percona.com/percona-operator-for-postgresql/2.0/delete.html

- https://medium.com/@haroldfinch01/how-to-delete-all-resources-from-kubernetes-one-time-a447ae08ffd8

```bash
kubectl delete all --all -n postgres-operator

# change finalizers to finalizers: []
kubectl edit crd xxx
```
