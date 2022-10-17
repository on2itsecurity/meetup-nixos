# Building a one-time activation package
On **any** OS with nix installed run the following command to build a one-time homemanager activation profile.

```console
[meetup@nixos-meetup:~]$ nix build github:on2itsecurity/meetup-nixos?dir=/home/meetup/.config/nixpkgs#homeConfigurations.meetup.activationPackage --no-write-lock-file
```

# Doing the one-time activation
```console
[meetup@nixos-meetup:~]$ result/activate 
Starting Home Manager activation
Activating checkFilesChanged
Activating checkLinkTargets
Activating writeBoundary
Activating installPackages
installing 'home-manager-path'
building '/nix/store/f837dwhgq9safg6m5878rjhzfdifpz5i-user-environment.drv'...
Activating linkGeneration
Creating profile generation 1
Creating home file links in /home/meetup
Activating onFilesChange
Activating reloadSystemd

[meetup@nixos-meetup:~]$ rm result
```

# Next
`home-manager` is now installed and managing itself.
From here on out, use the `home-manager` command.
```console
[meetup@nixos-meetup:~]$ home-manager generations 
2022-10-06 09:58 : id 1 -> /nix/store/hskq3yifx7vldqi5ic7b9hff3w6lng8m-home-manager-generation
```

Notice, for example that the users' git version is the one from `nixos/unstable`:
```console
[meetup@nixos-meetup:~]$ git --version
git version 2.37.3
```
While the systems' git version is the one from stable release `nixos/22.05`:
```console
[root@nixos-meetup:~]# git --version
git version 2.36.2
```

To download this example, use the convenience alias: `downloadMeetupHome` (you will need to re-login once, for this alias to be available).
```console
[meetup@nixos-meetup:~]$ downloadMeetupHome 
~/.config/nixpkgs ~
~
```

This should results in these home-manager configuration files:
```console
[meetup@nixos-meetup:~]$ ls -la ~/.config/nixpkgs/
total 20
drwxr-xr-x 2 meetup users 4096 Oct  6 10:34 .
drwxr-xr-x 6 meetup users 4096 Oct  6 10:18 ..
-rw-r--r-- 1 meetup users  572 Oct  6 10:34 flake.nix
-rw-r--r-- 1 meetup users  631 Oct  6 10:34 home.nix
```
