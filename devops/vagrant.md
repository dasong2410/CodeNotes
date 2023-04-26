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
