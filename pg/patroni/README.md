

sudo systemctl start patroni 
sudo systemctl stop patroni 
sudo systemctl restart patroni 
sudo systemctl status patroni 

sudo systemctl start postgresql


CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'rep-pass';




/etc/systemd/system/patroni.service




etcdctl ls -recursive



SELECT pg_is_in_recovery();




