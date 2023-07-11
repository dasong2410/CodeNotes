# Install PostgreSQL 9.1(deprecated) on Ubuntu 12.04(deprecated) via apt-get

## Setup apt-get source

- http://old-releases.ubuntu.com/ubuntu/

Ubuntu 12.04 is too old, the source file included in the os does not work anymore. It needs some modification. Just copy content of [ubuntu-12.04-source-list-old-releases](./ubuntu-12.04-source-list-old-releases.txt) to the following file:

```bash
/etc/apt/sources.list
```

and then, run

```bash
sudo apt-get update
```

## Install PostgreSQL 9.1

- https://www.postgresql.org/download/linux/ubuntu/
- https://www.postgresql.org/about/news/announcing-apt-archivepostgresqlorg-2024/
- https://askubuntu.com/questions/13065/how-do-i-fix-the-gpg-error-no-pubkey

```bash
sudo sh -c 'echo "deb https://apt-archive.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7FCC7D46ACCC4CF8
sudo apt-get update
sudo apt-get -y install postgresql-9.1
```

## Upgrade ubuntu

- https://askubuntu.com/questions/919795/how-to-upgrade-from-ubuntu-12-04-lts-to-the-latest-ubuntu-version
- https://askubuntu.com/questions/125392/why-is-no-new-release-found-when-upgrading-from-a-lts-to-the-next

The steps has to be incremental viz:
ubuntu 12.04 - 14.04 - 16.04 - 18.04 - 20.04 - 22.04

Check file /etc/update-manager/release-upgrades

```bash
root@node-1:~# cat /etc/update-manager/release-upgrades
# Default behavior for the release upgrader.

[DEFAULT]
# Default prompting behavior, valid options:
#
#  never  - Never check for a new release.
#  normal - Check to see if a new release is available.  If more than one new
#           release is found, the release upgrader will attempt to upgrade to
#           the release that immediately succeeds the currently-running
#           release.
#  lts    - Check to see if a new LTS release is available.  The upgrader
#           will attempt to upgrade to the first LTS release available after
#           the currently-running one.  Note that this option should not be
#           used if the currently-running release is not itself an LTS
#           release, since in that case the upgrader won't be able to
#           determine if a newer release is available.
Prompt=never
root@node-1:~#
```
If Prompt is newver, then change it to to lts

```bash
Prompt=lts
```

Proceed upgrade

```bash
sudo do-release-upgrade
```

## Remove old kernel images

### Remove old kernel images

```bash
dpkg --list | grep linux-image
sudo apt-get purge linux-image-4.4.0-210-generic
```

### Remove auto installed packages which are not in use now

```bash
sudo apt autoremove
```

