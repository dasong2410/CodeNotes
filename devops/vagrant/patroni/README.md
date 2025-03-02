
## PostgreSQL HA with Patroni 

- https://medium.com/@c.ucanefe/patroni-ha-proxy-feed1292d23f

### 1. Create vms using vagrant

- 192.168.8.51 - etcd, patroni, haproxy, and keepalived
- 192.168.8.52 - etcd, patroni, haproxy, and keepalived
- 192.168.8.53 - etcd, patroni, haproxy, and keepalived

```bash
# may need to restart services if don't open those ports in advance
sudo ufw allow 5432
sudo ufw allow 5000
sudo ufw allow 5001
```

- https://www.digitalocean.com/community/tutorials/how-to-set-up-time-synchronization-on-ubuntu-20-04
```bash
sudo apt install ntp

ntpq -p

timedatectl
sudo timedatectl set-timezone America/Vancouver
```

### 2. Install & config etcd on pg servers

```bash
sudo apt-get -y install etcd
sudo systemctl stop etcd

# copy file etc/default/etcd-[1|2|3] content to /etc/default/etcd

sudo systemctl daemon-reload
# start etcd simultaneously, or it will fail to start
sudo systemctl start etcd
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
sudo apt-get -y install postgresql-14
sudo pg_dropcluster 14 main --stop

sudo cp ~/.bashrc /var/lib/postgresql/.bash_profile
sudo chown postgres:postgres /var/lib/postgresql/.bash_profile
sudo chmod 664 /var/lib/postgresql/.bash_profile
```

```bash
sudo pg_createcluster 14 main -d /var/lib/postgresql/14/main --locale=en_US.UTF-8

sudo systemctl enable postgresql@14-main.service
sudo systemctl start postgresql@14-main.service

alter user postgres with password 'm#iA8wGGA8x@CU';
create user repl with replication encrypted password 'qK86J2raaK#vyz';
```

### 4. Install & config patroni on pg servers

```bash
sudo apt-get install patroni

# copy file etc/patroni/config-[1|2|3].conf content to /etc/patroni/config.yml

# setup parameter
export PATRONICTL_CONFIG_FILE=/etc/patroni/config.yml

# create patroni service
cat << EOF | sudo tee -a /etc/systemd/system/patroni.service
[Unit]
Description=Runners to orchestrate a high-availability PostgreSQL
After=syslog.target network.target

[Service]
Type=simple
User=postgres
Group=postgres
ExecStart=/usr/bin/patroni /etc/patroni/config.yml
KillMode=process
TimeoutSec=30
Restart=no

[Install]
WantedBy=multi-user.target
EOF

#sudo systemctl daemon-reload
sudo systemctl enable patroni
sudo systemctl start patroni
sudo systemctl status patroni
sudo systemctl stop patroni
sudo systemctl restart patroni

# after patron done the replication
sudo systemctl enable postgresql@14-main.service
sudo systemctl start postgresql@14-main.service
```

### 4. haproxy

```bash
sudo apt-get -y install haproxy
sudo systemctl start haproxy

# copy file xx content to /etc/haproxy/haproxy.cfg

sudo systemctl daemon-reload
sudo systemctl start haproxy
sudo systemctl status haproxy
sudo systemctl stop haproxy
sudo systemctl restart haproxy
```

### 5. keepalived
```bash
sudo apt install keepalived
sudo systemctl stop keepalived

# copy file etc/keepalived/keepalived-[1|2|3].conf content to /etc/keepalived/keepalived.conf

sudo systemctl daemon-reload
sudo systemctl start keepalived
sudo systemctl status keepalived
sudo systemctl stop keepalived
sudo systemctl restart keepalived
```


### 6. Testing
```bash
PGPASSWORD=m#iA8wGGA8x@CU psql -h 192.168.8.50 -p 5000 -U postgres -d test

SELECT pg_is_in_recovery();
```


### Commands

```bash
etcdctl member list
etcdctl ls -recursive
patronictl -c /etc/patroni/config.yml list

curl http://192.168.8.51:2379/metrics | grep wal
curl http://192.168.8.52:2379/metrics | grep wal
curl http://192.168.8.53:2379/metrics | grep wal
```

```bash
patronictl -c /etc/patroni/config.yml list 14-main
patronictl -c /etc/patroni/config.yml restart 14-main pg-1
patronictl -c /etc/patroni/config.yml restart 14-main pg-2
patronictl -c /etc/patroni/config.yml restart 14-main pg-3
```

### Add existing vms to vagrant
```bash
echo -n "f577766a-1b16-4b8d-be4c-eee12d171bac" > /data/Dev/vagrant/pg_hot_standby/.vagrant/machines/pg-1/virtualbox/id
echo -n "d20f983d-5b24-408c-9913-d47731c53623" > /data/Dev/vagrant/pg_hot_standby/.vagrant/machines/pg-2/virtualbox/id
echo -n "7fc6cfb4-297e-40d3-8ed3-44e080e7d83e" > /data/Dev/vagrant/pg_hot_standby/.vagrant/machines/pg-3/virtualbox/id

echo -n "bc6cb583-f6b6-46a3-98e1-7cb59bb1007d" > /data/Dev/vagrant/pg_hot_standby/.vagrant/machines/hap-1/virtualbox/id
echo -n "bb58b4ee-c422-49e8-b49e-a7a441c2337c" > /data/Dev/vagrant/pg_hot_standby/.vagrant/machines/hap-2/virtualbox/id
```

### 999. Errors

#### 999.1 FATAL:  could not open directory "/var/run/postgresql/14-main.pg_stat_tmp": No such file or directory

```bash
# fix: enable postgresql@14-main.service
sudo systemctl enable postgresql@14-main.service
sudo systemctl start postgresql@14-main.service
```
