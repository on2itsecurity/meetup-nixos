# LAB 0 

Use the lab details to log into your labs' serial console.
The lab machine's user is `root` and the password is `meetup123`.

Use the command `downloadMeetup` on the lab machine to download this meetup lab.

You can also install this nixos lab yourself by follow below details.

<details><summary>Click to show the details</summary>
<p>
  
## Installing nixos
This lab does not cover an entire nixos installation procedure. Instead it installs this meetups' nixos configuration directly from our git repository to get going quickly.

## Preparing the installer environment

- Login to the console of your virtual machine (4 cores, 2GB mem, 20GB HD, UEFI boot) and boot it from the iso (https://channels.nixos.org/nixos-22.05/latest-nixos-minimal-x86_64-linux.iso):
- Modify the root credentials, so we can login remotely using ssh: 
```console
[nixos@nixos]# sudo passwd
```

- Login to the remote installer environment using your favorite ssh client as root


## Partitioning the harddisk
- Execute the following commands to create partitions for our installation
```console
[root@nixos]# parted /dev/sda -- mklabel gpt
[root@nixos]# parted /dev/sda -- mkpart primary 512MB -8GB
[root@nixos]# parted /dev/sda -- mkpart primary linux-swap -8GB 100%
[root@nixos]# parted /dev/sda -- mkpart ESP fat32 1MB 512MB
[root@nixos]# parted /dev/sda -- set 3 esp on
```
- Format the partitions
```console
[root@nixos]# mkfs.ext4 -L nixos /dev/sda1
[root@nixos]# mkswap -L swap /dev/sda2
[root@nixos]# mkfs.fat -F 32 -n boot /dev/sda3
```
- Mount partitions
```console
[root@nixos]# mount /dev/disk/by-label/nixos /mnt
[root@nixos]# mkdir -p /mnt/boot
[root@nixos]# mount /dev/disk/by-label/boot /mnt/boot
[root@nixos]# swapon /dev/sda2
```

## Install the meetup nixos installation directly from our repository
- Enter the following command to install
```console
[root@nixos]# nixos-install --no-root-passwd --flake github:on2itsecurity/meetup-nixos#nixos-meetup
```
- Reboot the machine (this will stop your ssh session from working)
```console
[root@nixos]# reboot
```

## Download the meetup config (login as root, password is meetup123)
- Login to the console of your assigned virtual machine and execute the below command. This will download the repository to your `/etc/nixos` directory so you can work directly on the machine
```console
[root@nixos-meetup]# downloadMeetup
```
- Check the contents of `/etc/nixos` and make sure the repository was downloaded properly. This should look similar too:
```console
[root@nixos-meetup]# ls -l /etc/nixos
total 56
drwxr-xr-x  5 root root 4096 Oct  7 19:28  .
drwxr-xr-x 23 root root 4096 Oct  7 19:30  ..
-rw-rw-r--  1 root root  751 Oct  7 19:20  configuration.nix
-rw-rw-r--  1 root root 1098 Oct  7 19:20  flake.lock
-rw-rw-r--  1 root root  870 Oct  7 19:20  flake.nix
drwxrwxr-x  3 root root 4096 Oct  7 19:20  home
-rw-rw-r--  1 root root 2469 Oct  7 19:20 'LAB0 - vm setup.md'
-rw-rw-r--  1 root root 1717 Oct  7 19:20 'LAB1 - configure ssh.md'
-rw-rw-r--  1 root root 1149 Oct  7 19:20 'LAB2 - upgrade the system.md'
-rw-rw-r--  1 root root  565 Oct  7 19:20 'LAB3 - break stuff.md'
-rw-rw-r--  1 root root 2128 Oct  7 19:20 'LAB4 - secrets in nixos.md'
-rw-rw-r--  1 root root  467 Oct  7 19:20 'LAB5 - home-manager.md'
drwxrwxr-x  2 root root 4096 Oct  7 19:20  nixos-meetup
drwxrwxr-x  2 root root 4096 Oct  7 19:32  nixos-meetup-gcloud
```

</p>
</details>

## End of LAB0
This is the end of the lab.
