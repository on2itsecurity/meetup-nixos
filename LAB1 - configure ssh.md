# LAB1 - configuring sshd


## 1.1 Enable sshd
- Using https://search.nixos.org, and going through the nixos options, find how to configure openssh.
- On the VM console, login as root user and edit the configuration and add a section to enable sshd and allow root to login WITH a password. (This is not best pratice, but convenient during the labs)
- Run `nixos-rebuild switch` to activate your new configuration.


## Answer
<details><summary>Click to show the answer</summary>
<p>
  
```nix
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";
```
  
</p>
</details>

You should now be able to login to your machine using ssh.
All subsequent excercises and labs will use ssh to login to the machine.

## 1.2: Create your own user 'meetup' and add your ssh public key
- Add a normal user account for yourself, set a `hashedPassword` and (optionally) add your ssh public key to the users' account.

## Answer
<details><summary>Click to show the answer</summary>
<p>
  
```nix
  users.users.meetup = {
    hashedPassword = "$6$PpPH1dvBocKgYSgk$D9wjRfYXZWpB9BS/Cnmyc.S1lp6Ffnjl18FuCGNY724bsEGAC4UUbDSWeMVxY7iycZRFKVmUi56qOvGqv2Mmg/";
    # see https://search.nixos.org/options?channel=22.05&show=users.users.<name>.hashedPassword&query=users.users.<name>.hashedPassword
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICZ3H6O6bUfOMHzPLaL3QIDz5WMqKePJdCtFN1yP9nFQ"
    ];
  };
```
  
</p>
</details>

You should now be able to login to your machine using ssh and your own user and ssh key.

Bonus excersise: enable `sudo` and allow your user to use it to run commands as `root` and disable password-based root login.

## End of LAB1
This is the end of the lab.
