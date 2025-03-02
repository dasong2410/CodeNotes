# Vagrant

https://developer.hashicorp.com/vagrant/tutorials/getting-started/getting-started-index

### check status

```bash
-> % vagrant status
Current machine states:

node-1                    running (virtualbox)
node-2                    running (virtualbox)
node-3                    running (virtualbox)
```

### ssh to vagrant virtual machine

```bash
-> % vagrant ssh node-1
Welcome to Ubuntu 22.04.2 LTS (GNU/Linux 5.15.0-67-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Tue Mar 21 10:38:26 PM UTC 2023

  System load:  1.02734375         Users logged in:          1
  Usage of /:   15.2% of 30.34GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 17%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.56.4
  Processes:    151

 * Introducing Expanded Security Maintenance for Applications.
   Receive updates to over 25,000 software packages with your
   Ubuntu Pro subscription. Free for personal use.

     https://ubuntu.com/pro


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Tue Mar 21 22:07:51 2023 from 10.0.2.2
vagrant@node-1:~$
```

Vagrant network config : NAT + NAT network + HostOnly
https://gist.github.com/lktslionel/e11813996644313f997944c7a99be1f0



```bash
VBoxManage  list vms


echo -n "f577766a-1b16-4b8d-be4c-eee12d171bac" > /data/Dev/vagrant/pg_hot_standby/.vagrant/machines/pg-1/virtualbox/id
echo -n "d20f983d-5b24-408c-9913-d47731c53623" > /data/Dev/vagrant/pg_hot_standby/.vagrant/machines/pg-2/virtualbox/id
echo -n "7fc6cfb4-297e-40d3-8ed3-44e080e7d83e" > /data/Dev/vagrant/pg_hot_standby/.vagrant/machines/pg-3/virtualbox/id

echo -n "bc6cb583-f6b6-46a3-98e1-7cb59bb1007d" > /data/Dev/vagrant/pg_hot_standby/.vagrant/machines/hap-1/virtualbox/id
echo -n "bb58b4ee-c422-49e8-b49e-a7a441c2337c" > /data/Dev/vagrant/pg_hot_standby/.vagrant/machines/hap-2/virtualbox/id

echo -n "c2448633-e3a5-4b6a-98f1-5519e9e156c1" > /data/Dev/vagrant/k8s/.vagrant/machines/node-1/virtualbox/id
echo -n "dfed969e-b70c-43b1-95e7-23c3ed0821b5" > /data/Dev/vagrant/k8s/.vagrant/machines/node-2/virtualbox/id
echo -n "b59be5f0-3149-4c97-b44d-8a4da5cfc5f9" > /data/Dev/vagrant/k8s/.vagrant/machines/node-3/virtualbox/id



vagrant ssh-config


create public key from private key, and then copy this key to every vm
ssh-keygen -y -f vagrant.key.rsa > vagrant.key.rsa.pub
```