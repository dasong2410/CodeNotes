
## PostgreSQL HA with Patroni 

- https://medium.com/@c.ucanefe/patroni-ha-proxy-feed1292d23f
- https://github.com/etcd-io/etcd/tree/main/hack/tls-setup
- https://www.cyberciti.biz/faq/unix-linux-check-if-port-is-in-use-command/

### Preparation

```bash
# new server check/set timezone(root)
sudo timedatectl
sudo timedatectl set-timezone America/Vancouver

# install language pack
locale -a
sudo apt-get -y install language-pack-en

# change editor for crontab
select-editor

# There maybe some python errors related to ssl lib changes, upgrade to the latest version
sudo apt install python3-pip
pip install --upgrade pyopenssl cryptography
```

```bash
# create certificate files
curl -L -o bin/cfssl https://github.com/cloudflare/cfssl/releases/download/v1.6.5/cfssl_1.6.5_linux_amd64
curl -L -o bin/cfssljson https://github.com/cloudflare/cfssl/releases/download/v1.6.5/cfssljson_1.6.5_linux_amd64
chmod +x bin/cfssl
chmod +x bin/cfssljson

export infra0=etcd
export infra1=patroni
export infra2=others
make
find certs -name "*key*" -exec chmod 644 {} \;
sudo chmod -R 655 /home/data
sudo cp -r certs /home/data/
```

```bash
# declare env variables on every host
# host1
export vip=192.168.8.50
export ip0=192.168.8.51 # current node ip
export ip1=192.168.8.51
export ip2=192.168.8.52
export ip3=192.168.8.53
export num=1
export fp=103 # failover priority

# host2
export vip=192.168.8.50
export ip0=192.168.8.52 # current node ip
export ip1=192.168.8.51
export ip2=192.168.8.52
export ip3=192.168.8.53
export num=2
export fp=102 # failover priority

# host3
export vip=192.168.8.50
export ip0=192.168.8.53 # current node ip
export ip1=192.168.8.51
export ip2=192.168.8.52
export ip3=192.168.8.53
export num=3
export fp=101 # failover priority
```

### 1. Create vms using vagrant

- 192.168.8.51 - etcd, patroni, haproxy, and keepalived
- 192.168.8.52 - etcd, patroni, haproxy, and keepalived
- 192.168.8.53 - etcd, patroni, haproxy, and keepalived

```bash
# may need to restart services if don't open those ports in advance
sudo ufw allow ssh
sudo ufw enable

# sudo ufw allow from x.x.x.x to any port 5432
# sudo ufw allow from x.x.x.0/24
# sudo ufw delete allow from x.x.x.0/24

sudo ufw allow 5432
sudo ufw allow 6432

sudo ufw allow 5000
sudo ufw allow 5001
sudo ufw allow 7000

sudo ufw allow 2379
sudo ufw allow 2380

sudo ufw allow 8008
```

- https://www.digitalocean.com/community/tutorials/how-to-set-up-time-synchronization-on-ubuntu-20-04
```bash
sudo apt update
sudo apt -y install ntp
sudo ntpq -p
sudo timedatectl
sudo timedatectl set-timezone America/Vancouver
```

### 2. Install & config etcd on pg servers

- https://github.com/etcd-io/etcd/releases
- https://github.com/etcd-io/etcd/releases/download/v3.6.1/etcd-v3.6.1-linux-amd64.tar.gz

```bash
sudo apt update
sudo apt -y install etcd
sudo systemctl stop etcd

wget https://github.com/etcd-io/etcd/releases/download/v3.6.1/etcd-v3.6.1-linux-amd64.tar.gz
tar -xzvf etcd-v3.6.1-linux-amd64.tar.gz
sudo cp etcd-v3.6.1-linux-amd64/etcd* /usr/bin/

sed -e "s/{num}/${num}/g" \
    -e "s/{0}/${ip0}/g" \
    -e "s/{1}/${ip1}/g" \
    -e "s/{2}/${ip2}/g" \
    -e "s/{3}/${ip3}/g" etc/default/template-etcd | sudo tee /etc/default/etcd

# add env variables to .profile
export ETCDCTL_CERT=/home/data/certs/etcd/etcd.pem
export ETCDCTL_KEY=/home/data/certs/etcd/etcd-key.pem
export ETCDCTL_CACERT=/home/data/certs/ca.pem

sudo systemctl daemon-reload
sudo systemctl start etcd
sudo systemctl stop etcd
sudo systemctl status etcd
sudo systemctl restart etcd
```

### 3. Install pg & create db cluster

```bash
# Create the file repository configuration:
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Import the repository signing key:
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update the package lists:
sudo apt-get update

# Install the latest version of PostgreSQL.
# If you want a specific version, use 'postgresql-12' or similar instead of 'postgresql':
sudo apt-get -y install postgresql-17
sudo pg_dropcluster 17 main --stop

sudo chown postgres:postgres /var/lib/postgresql

sudo cp /etc/skel/.bashrc /var/lib/postgresql/
sudo cp /etc/skel/.profile /var/lib/postgresql/
sudo chown postgres:postgres /var/lib/postgresql/.bashrc
sudo chown postgres:postgres /var/lib/postgresql/.profile
sudo chmod 664 /var/lib/postgresql/.bashrc
sudo chmod 664 /var/lib/postgresql/.profile

# remove postgres log rotation conf, and then create a new one
sudo mv /etc/logrotate.d/postgresql-common /home/data/
sudo cp etc/logrotate.d/postgresql-test /etc/logrotate.d/
sudo chmod 644 /etc/logrotate.d/postgresql-test

# create test user
create user marcus with password 'Muster-Cresting-Reexamine4-Morbidly-Ferry';
```

```bash
sudo pg_createcluster 17 test -d /var/lib/postgresql/17/test --locale=en_US.UTF-8

sudo systemctl enable postgresql@17-test.service
sudo systemctl start postgresql@17-test.service

alter user postgres with password 'm#iA8wGGA8x@CU';
create user repl with replication encrypted password 'qK86J2raaK#vyz';
```

### 4. Install & config patroni on pg servers

```bash
sudo apt -y install patroni

# create config file
sed -e "s/{num}/${num}/g" \
    -e "s/{0}/${ip0}/g" \
    -e "s/{1}/${ip1}/g" \
    -e "s/{2}/${ip2}/g" \
    -e "s/{3}/${ip3}/g" \
    -e "s/{fp}/${fp}/g" etc/patroni/template-config.yml | sudo tee /etc/patroni/config.yml

# setup parameter
export PATRONICTL_CONFIG_FILE=/etc/patroni/config.yml

#sudo systemctl daemon-reload
sudo systemctl enable patroni
sudo systemctl start patroni
sudo systemctl stop patroni
sudo systemctl status patroni
sudo systemctl restart patroni

# after patron done the replication
sudo systemctl enable postgresql@17-test.service
sudo systemctl start postgresql@17-test.service
```

### 4. pgbouncer

- https://www.cybertec-postgresql.com/en/pgbouncer-authentication-made-easy/

```sql
-- create an user for pgbouncer under database postgres
create user pgbouncer;
-- set a password for the user
-- Viral2-Campsite-Gleaming-Scrabble-Rockiness
\password pgbouncer

-- drop function public.lookup(name);
create or replace function public.lookup
(
  inout p_user   name,
  out p_password text
) returns record
  language sql
  security definer set search_path = pg_catalog
as
$$
select usename, passwd
from pg_shadow
where usename = p_user
$$;

-- make sure only 'pgbouncer' can use the function
revoke execute on function public.lookup(name) from public;
grant execute on function public.lookup(name) to pgbouncer;
```

```bash
sudo apt -y install pgbouncer
sudo systemctl start pgbouncer
sudo systemctl stop pgbouncer
sudo systemctl status pgbouncer
sudo systemctl restart pgbouncer
```

### 5. haproxy

- https://github.com/pgsty/pigsty/issues/175
- https://www.percona.com/blog/haproxy-patroni-setup-using-health-check-endpoints-and-debugging/

```bash
sudo apt -y install haproxy

# create config file
sed -e "s/{1}/${ip1}/g" \
    -e "s/{2}/${ip2}/g" \
    -e "s/{3}/${ip3}/g" etc/haproxy/template-haproxy.cfg | sudo tee /etc/haproxy/haproxy.cfg

sudo systemctl daemon-reload
sudo systemctl start haproxy
sudo systemctl stop haproxy
sudo systemctl status haproxy
sudo systemctl restart haproxy
```

### 6. keepalived
```bash
sudo apt -y install keepalived
sudo systemctl stop keepalived

# create config file, change priority after
sed -e "s/{vip}/${vip}/g" \
    -e "s/{0}/${ip0}/g" \
    -e "s/{1}/${ip1}/g" \
    -e "s/{2}/${ip2}/g" \
    -e "s/{3}/${ip3}/g" \
    -e "s/{fp}/${fp}/g" \
    sed -e "21,100s/${ip0}//g" etc/keepalived/template-keepalived.conf | sudo tee /etc/keepalived/keepalived.conf

sudo systemctl daemon-reload
sudo systemctl start keepalived
sudo systemctl stop keepalived
sudo systemctl status keepalived
sudo systemctl restart keepalived
```


### 6. Testing
```bash
PGPASSWORD=m#iA8wGGA8x@CU psql -h 192.168.8.50 -p 5000 -U postgres -d test

SELECT pg_is_in_recovery();

psql -p 6432 -U marcus -d postgres -h 127.0.0.1
psql -p 5000 -U marcus -d postgres -h 127.0.0.1
```


### 998. Commands

```bash
etcdctl member list -w table
etcdctl endpoint status --cluster
etcdctl endpoint health --cluster

patronictl list
patronictl list 17-main
patronictl restart 17-main pg-1

curl https://192.168.8.51:2379/metrics --cacert --cacert /home/data/certs/patroni/patroni.pem | grep wal
curl http://192.168.8.52:2379/metrics | grep wal
curl http://192.168.8.53:2379/metrics | grep wal

curl -s https://192.168.8.51:8008/patroni --cacert /home/data/certs/patroni/patroni.pem | jq
curl https://192.168.8.51:8008/patroni --cacert /home/data/certs/patroni/patroni.pem | jq

```

### 999. Errors

#### 999.1 FATAL:  could not open directory "/var/run/postgresql/17-main.pg_stat_tmp": No such file or directory

```bash
# fix: enable postgresql@17-main.service
sudo systemctl enable postgresql@17-main.service
sudo systemctl start postgresql@17-main.service
```
