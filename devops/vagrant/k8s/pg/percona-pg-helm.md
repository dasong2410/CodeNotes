## Percona Operator for PostgreSQL

```bash
vagrant@m-1:~$ helm repo add percona https://percona.github.io/percona-helm-charts/
helm repo update
"percona" has been added to your repositories
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "percona" chart repository
Update Complete. ⎈Happy Helming!⎈
vagrant@m-1:~$
vagrant@m-1:~$
vagrant@m-1:~$
vagrant@m-1:~$
vagrant@m-1:~$ kubectl create namespace postgres-operator
namespace/postgres-operator created
vagrant@m-1:~$
vagrant@m-1:~$
vagrant@m-1:~$ helm install my-operator percona/pg-operator --namespace postgres-operator
NAME: my-operator
LAST DEPLOYED: Fri Jan 10 01:22:01 2025
NAMESPACE: postgres-operator
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
1. Percona Operator for PostgreSQL is deployed.
  See if the operator Pod is running:

    kubectl get pods -l app.kubernetes.io/name=pg-operator --namespace postgres-operator

  Check the operator logs if the Pod is not starting:

    export POD=$(kubectl get pods -l app.kubernetes.io/name=pg-operator --namespace postgres-operator --output name)
    kubectl logs $POD --namespace=postgres-operator

2. Deploy the database cluster from pg-db chart:

    helm install my-db percona/pg-db --namespace=postgres-operator

Read more in our documentation: https://docs.percona.com/percona-operator-for-postgresql/2.0/
vagrant@m-1:~$ helm install cluster1 percona/pg-db -n postgres-operator
NAME: cluster1
LAST DEPLOYED: Fri Jan 10 01:22:50 2025
NAMESPACE: postgres-operator
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
#

                    %                        _____
                   %%%                      |  __ \
                 ###%%%%%%%%%%%%*           | |__) |__ _ __ ___ ___  _ __   __ _
                ###  ##%%      %%%%         |  ___/ _ \ '__/ __/ _ \| '_ \ / _` |
              ####     ##%       %%%%       | |  |  __/ | | (_| (_) | | | | (_| |
             ###        ####      %%%       |_|   \___|_|  \___\___/|_| |_|\__,_|
           ,((###         ###     %%%        _      _          _____                       _
          (((( (###        ####  %%%%       | |   / _ \       / ____|                     | |
         (((     ((#         ######         | | _| (_) |___  | (___   __ _ _   _  __ _  __| |
       ((((       (((#        ####          | |/ /> _ </ __|  \___ \ / _` | | | |/ _` |/ _` |
      /((          ,(((        *###         |   <| (_) \__ \  ____) | (_| | |_| | (_| | (_| |
    ////             (((         ####       |_|\_\\___/|___/ |_____/ \__, |\__,_|\__,_|\__,_|
   ///                ((((        ####                                  | |
 /////////////(((((((((((((((((########                                 |_|   Join @ percona.com/k8s


Join Percona Squad! Get early access to new product features, invite-only ”ask me anything” sessions with Percona Kubernetes experts, and monthly swag raffles.

>>> https://percona.com/k8s <<<

To get a PostgreSQL prompt inside your new cluster you can run:

  PGBOUNCER_URI=$(kubectl -n postgres-operator get secrets cluster1-pg-db-pguser-cluster1-pg-db -o jsonpath="{.data.pgbouncer-uri}" | base64 --decode)

And then connect to a cluster with a temporary Pod:

  $ kubectl run -i --rm --tty percona-client --image=perconalab/percona-distribution-postgresql:16 --restart=Never \
  -- psql $PGBOUNCER_URI
```