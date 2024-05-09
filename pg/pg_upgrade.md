# Upgrade

## Test script

```sql
create database test with encoding = 'SQL_ASCII' template = template0;
\c test

create table t_test(c1 int, c2 int);

insert into t_test values(1,1),(2,2);
select * from t_test;


create or replace function func_test()
    returns varchar
as
$$
declare
begin
    return 'Welcome to new PostgreSQL Version';
end;
$$ language plpgsql;

```

## Install PostgreSQL via binary

Download PostgreSQL 9.1

- https://www.enterprisedb.com/downloads/postgres-postgresql-downloads

```bash
# sudo dpkg -i <package path>
wget https://get.enterprisedb.com/postgresql/postgresql-9.1.24-1-linux-x64.run
chmod +x postgresql-9.1.24-1-linux-x64.run
sudo ./postgresql-9.1.24-1-linux-x64.run
```

## Install PostgreSQL via apt-get

- https://www.postgresql.org/download/linux/ubuntu/

```bash
sudo apt-get -y install postgresql-9.1
sudo apt-get -y install postgresql-14
```

To prevent unintended upgrades, you can pin the package at the currently installed version:

```bash
sudo apt-mark hold <package_name>
sudo apt-mark unhold <package_name>
sudo apt-mark showhold
```

### List installed packages

```bash
dpkg --get-selections | grep postgres
apt list --installed | grep postgres
```

## Upgrade via pg_upgrade(9.1 to 14)

### 1. Install 9.1 and 14

See installation via binary

### 2. Run test script to stock database on 9.1

### 3. Related directories

    /opt/PostgreSQL/9.1/data
    /opt/PostgreSQL/9.1/bin

    /etc/postgresql/14/main
    /usr/lib/postgresql/14/bin
    /var/lib/postgresql/14/main
    /var/log/postgresql

### 4. Upgrade

- https://www.postgresql.org/docs/14/pgupgrade.html

```bash
# create a cluster
sudo pg_createcluster 14 main -d /var/lib/postgresql/clusters/14/main --locale=en_US.UTF-8 --start-conf=manual

/usr/lib/postgresql/14/bin/pg_upgrade -b /opt/PostgreSQL/9.1/bin -B /usr/lib/postgresql/14/bin -d /opt/PostgreSQL/9.1/data -D /etc/postgresql/14/main --check

/usr/lib/postgresql/14/bin/pg_upgrade -b /opt/PostgreSQL/9.1/bin -B /usr/lib/postgresql/14/bin -d /opt/PostgreSQL/9.1/data -D /etc/postgresql/14/main

```

## upgrade via pg_upgradecluster(9.1 to 14)

### 1. Install 9.1 and 14

See installaction via apt-get above.

pg_createcluster 14 main -d /var/lib/postgresql/14/main --locale=en_US.UTF-8

### 2. Run test script to stock database on 9.1

### 3. Related directories

    /etc/postgresql/9.1/main
    /usr/lib/postgresql/9.1/bin
    /var/lib/postgresql/9.1/main
    /var/log/postgresql

    /etc/postgresql/14/main
    /usr/lib/postgresql/14/bin
    /var/lib/postgresql/14/main
    /var/log/postgresql

### 4. Upgrade

- https://gorails.com/guides/upgrading-postgresql-version-on-ubuntu-server

```bash
sudo systemctl stop postgresql

sudo pg_renamecluster 14 main main_old
sudo pg_upgradecluster 9.1 main

sudo pg_upgradecluster -v 14 --rename main -m upgrade 9.1 main /var/lib/postgresql/clusters/14/main
pg_lsclusters
```

### 4. Varify

```sql
psql -p 5432
\c test

select * from t_test;
select func_test();
```


## After upgrade

```bash
vacuumdb -a -f -z -v
reindexdb -a -v
```

    Your installation contains extensions that should be updated
    with the ALTER EXTENSION command.  The file
        update_extensions.sql
    when executed by psql by the database superuser will update
    these extensions.

    Upgrade Complete
    ----------------
    Optimizer statistics are not transferred by pg_upgrade so,
    once you start the new server, consider running:
        ./analyze_new_cluster.sh

    Running this script will delete the old cluster's data files:
        ./delete_old_cluster.sh


## Others

### 1. Start postgresql after external disks mount

- https://unix.stackexchange.com/questions/246935/set-systemd-service-to-execute-after-fstab-mount


### 2. Systemd conf
```bash
/etc/systemd
/lib/systemd
/run/systemd/generator/postgresql.service.wants
/etc/systemd/system/multi-user.target.wants/postgresql.service -> /lib/systemd/system/postgresql.service
'/run/systemd/generator/postgresql.service.wants/postgresql@14-main.service' -> '/lib/systemd/system/postgresql@.service'
```

### 3. Start/stop PostgreSQL 

```bash
/usr/lib/postgresql/9.1/bin/postgres -D /var/lib/postgresql/9.1/main

/usr/lib/postgresql/9.1/bin/pg_ctl -D /var/lib/postgresql/9.1/main start
/usr/lib/postgresql/9.1/bin/pg_ctl -D /var/lib/postgresql/9.1/main stop

/usr/lib/postgresql/14/bin/pg_ctl -D /etc/postgresql/14/main start
/usr/lib/postgresql/14/bin/pg_ctl -D /etc/postgresql/14/main stop
```

```bash
sudo systemctl stop postgresql@14-main

sudo systemctl start postgresql
sudo systemctl stop postgresql
sudo systemctl status postgresql
```

### 4. Logrotate

- https://www.postgresql.org/docs/14/logfile-maintenance.html

### 99. Vagrant

```bash
# This defines the version of vagrant
Vagrant.configure(2) do |config|
  # Specifying the box we wish to use
    config.vm.box = "bento/ubuntu-22.04"
  # Adding Bridged Network Adapter
  # config.vm.network "public_network"
  config.vm.network "private_network", :type => 'dhcp'
  
  # Iterating the loop for three times
  (1..1).each do |i|
    # Defining VM properties
    config.vm.define "node-#{i}" do |node|
      node.vm.hostname = "node-#{i}"
      # node.vm.network "private_network", :type => 'dhcp'
      # Specifying the provider as VMWare and naming the VM's
      config.vm.provider "virtualbox" do |v|
        # The VM will be named as node-{i}
        # if setup this parameter will raise error,
        # because only the lastest nodename will be used, even when creating the first node, maybe it's a bug
        # v.name = "node-#{i}"
        # v.gui = true
        v.linked_clone = true
        v.check_guest_additions = false
      end
    end
  end
end
```
