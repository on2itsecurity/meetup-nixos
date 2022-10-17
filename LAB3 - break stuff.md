# LAB 3 - Breaking stuff (and fix it)

## 3.1: Destroy your networking
Disable dhcp on you network interface and watch your connection break "by accident".

## Answer
<details><summary>Click to show the answer</summary>
<p>
  
```nix
  networking.useDHCP = false;
```

</p>
</details>
  
## 3.2: Rollback to the last generation
Rebuild your system using a rollback to the previous generation of your system.
Use the serial console for this!

## Answer
<details><summary>Click to show the answer</summary>
<p>
  
```console
[root@nixos]# nixos-rebuild switch --rollback
```

</p>
</details>

## 3.3: Break it again
Use `nixos-rebuild switch` to activate your broken configuration again

and

List the available generations of your system.

## Answer
<details><summary>Click to show the answer</summary>
<p>
  
```console
[root@nixos]# nix-env --list-generations --profile /nix/var/nix/profiles/system
```

</p>
</details>

Reboot the system (on console enter `reboot`) and select a working generation from the GRUB boot menu.
*(notice you can even rollback your system to before the OS upgrade)*

## 3.4: Remove the config from 3.1
This should put your system in a working state again.

Bonus excersise: Use the `nix-env` command to switch your system to a specific generation number
## Answer
<details><summary>Click to show the answer</summary>
<p>
  
```console
[root@nixos]# nix-env --profile /nix/var/nix/profiles/system --switch-generation <number>
```

</p>
</details>

## End of LAB3
This is the end of the lab.
