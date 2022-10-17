# LAB2 - upgrading nixos

# 2.1: install git in the system profile
- Install the `git` package in your `systemPackages`. This is a prerequisite for upgrading the system `flake.nix`
- Rebuild your system

## Answer
<details><summary>Click to show the answer</summary>
<p>
  
```nix
  environment.systemPackages = [ pkgs.git ];
```
  
</p>
</details>

This will install git into your system profile.
```console
[root@nixos-meetup:~]$ git --version
git version 2.36.2
```

## 2.2: do an entire OS upgrade
- Edit your system flake and pin to `nixos-22.05` (latest stable version).
- Rebuild your system


## Answer
<details><summary>Click to show the answer</summary>
<p>
  
In `/etc/nixos/flake.nix` change `nixpkgs.url` accordingly:
  
```nix
  nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
```
  
</p>
</details>

You are now running a new version of `nixos 22.05` that is installed alongside your existing `nixos 21.11` OS.
```console
[root@nixos-meetup:~]$ nixos-version                        
22.05.20221004.fe76645 (Quokka)
```

Bonus excercise: find the command to update your flake inputs

## End of LAB2
This is the end of the lab.
