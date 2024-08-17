
### 1. Prepare vms

Use Vagrantfile to create vms

    open port 5432
    sudo ufw allow 5432
    restart pg

```bash
# FATAL:  could not open directory "/var/run/postgresql/14-main.pg_stat_tmp": No such file or directory
# fix: enable postgresql@14-main.service
sudo systemctl enable postgresql@14-main.service
sudo systemctl start postgresql@14-main.service
```

### 1. install, config etcd

```bash
/etc/default/etcd
```

### 2. install pg, create db cluster

### 3. install, config patroni

```bash
/etc/patroni/config.yml
```

### 4. haproxy, keepalived

```bash
/etc/haproxy/haproxy.cfg
systemctl restart haproxy
systemctl stop haproxy

sudo apt install keepalived
sudo vi /etc/keepalived/keepalived.conf


sudo systemctl start keepalived
sudo systemctl enable keepalived



create pg cluster
CREATE USER repl WITH REPLICATION ENCRYPTED PASSWORD 'qK86J2raaK#vyz';

sudo apt-get install patroni

sudo vi /etc/systemd/system/patroni.service



sudo systemctl start patroni
sudo systemctl stop patroni
sudo systemctl restart patroni
sudo systemctl status patroni

sudo systemctl start postgresql


etcdctl ls -recursive



SELECT pg_is_in_recovery();


patronictl -c /etc/patroni/config.yml list






PGPASSWORD=m#iA8wGGA8x@CU psql -h 192.168.56.103 -p 5000 -U postgres -d test1

https://medium.com/@c.ucanefe/patroni-ha-proxy-feed1292d23f
```


### Etcd commands

```bash
etcdctl member list


curl http://192.168.56.111:2379/metrics | grep wal
curl http://192.168.56.112:2379/metrics | grep wal
curl http://192.168.56.113:2379/metrics | grep wal
```

### Patroni commands

```bash
patronictl -c /etc/patroni/config.yml list 14-main
patronictl -c /etc/patroni/config.yml restart 14-main pg-1
```




### Add existing vms to vagrant
```bash
echo -n "f577766a-1b16-4b8d-be4c-eee12d171bac" > /data/Dev/vagrant/pg_hot_standby/.vagrant/machines/pg-1/virtualbox/id
echo -n "d20f983d-5b24-408c-9913-d47731c53623" > /data/Dev/vagrant/pg_hot_standby/.vagrant/machines/pg-2/virtualbox/id
echo -n "7fc6cfb4-297e-40d3-8ed3-44e080e7d83e" > /data/Dev/vagrant/pg_hot_standby/.vagrant/machines/pg-3/virtualbox/id

echo -n "bc6cb583-f6b6-46a3-98e1-7cb59bb1007d" > /data/Dev/vagrant/pg_hot_standby/.vagrant/machines/hap-1/virtualbox/id
echo -n "bb58b4ee-c422-49e8-b49e-a7a441c2337c" > /data/Dev/vagrant/pg_hot_standby/.vagrant/machines/hap-2/virtualbox/id
```

### etcd metrics

```bash
curl http://192.168.56.111:2379/metrics
```