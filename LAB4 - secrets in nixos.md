# LAB 4 - Using secrets

## 4.1: create a 'secret' file
Create a file on the filesystem at `/etc/nixos/secret.file` with some 'secret' content (use a text-editor for example).
Next, add this file to your nixos configuration to be available at `/etc/myfile`.
Make sure you use a path relative to the `configuration.nix` (use `./secret.file`)

## Answer
<details><summary>Click to show the answer</summary>
<p>
  
```console
[root@nixos]# echo "mysupersecret" > /etc/nixos/secret.file
```
```nix
  environment.etc."myfile".source = ./secret.file;
```
  
</p>
</details>

This should add the file at the configured location.
```console
[root@nixos]# ls -la /etc/myfile
lrwxrwxrwx 1 root root 18 Oct  4 15:01 /etc/myfile -> /etc/static/myfile
[root@nixos]# ls -la /etc/static/myfile
lrwxrwxrwx 2 root root 55 Jan  1  1970 /etc/static/myfile -> /nix/store/v9qkmx17ffkqikvvhibv3px6v4nyrx4w-secret.file
[root@nixos]# ls -la /nix/store/v9qkmx17ffkqikvvhibv3px6v4nyrx4w-secret.file
-r--r--r-- 5 root root 14 Jan  1  1970 /nix/store/v9qkmx17ffkqikvvhibv3px6v4nyrx4w-secret.file
```
*(notice it is world readable)*
```console
[root@nixos]# cat /nix/store/v9qkmx17ffkqikvvhibv3px6v4nyrx4w-secret.file
mysupersecret
```
*(notice it is clear text)*


## 4.2: Fix this problem using agenix

In this excercise we will use agenix to create an encrypted file that can (and will) be safely stored on the filesystem.

Agenix requires ssh keys. As a prerequisite, generate a new ssh keypair to encrypt new files. In normal situations you can use your own.

```console
[root@nixos]# ssh-keygen -t ed25519
```

Create a new `secrets.nix` configuration which is used by the `agenix` CLI to know which public keys are allowed to decrypts the secret you are about to create in the following step.
(Use both your machine (`cat /etc/ssh/ssh_host_ed25519_key.pub`) and user (`cat ~/.ssh/id_ed25519.pub`)  public key so you can edit this file later on.)

## Answer
<details><summary>Click to show the answer</summary>
<p>

Contents of `secrets.nix`:
```nix
{
  "my-file.age".publicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICZ3H6O6bUfOMHzPLaL3QIDz5WMqKePJdCtFN1yP9nFQ"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK3SjEfSTqBzMxXOq1wAvx0WKmdSp4G3NVOa/8HY23rT"
  ];
}
```
  
</p>
</details>

Edit the encrypted secrets file using your private key for the configured destination public keys (from secrets.nix)
`nix run github:ryantm/agenix -- --identity ~/.ssh/id_ed25519 -e my-file.age`
*(in the editor enter the text "my-super-secret")*


Configure your new file to be an age secret.

## Answer
<details><summary>Click to show the answer</summary>
<p>
  
Add the following to your `configuration.nix`:
  
```nix
  age.secrets.my-file = {
    file = ./my-file.age; # age encrypted file
    path = "/etc/myfile"; # destination where the decypted file will be linked to
  };
```
  
</p>
</details>

This should add the file at the configured location.
```console
[root@nixos]# ls -la /etc/myfile
lrwxrwxrwx 1 root root 19 Oct  4 15:22 /etc/myfile -> /run/agenix/my-file
[root@nixos]# ls -la /run/agenix/my-file
-r-------- 1 root root 16 Oct  4 15:22 /run/agenix/my-file 
```
*(notice the file is nolonger world readable)*

The decrypted file is stored in RAM only, the file in the nix store is the encrypted age secret.

## End of LAB4
This is the end of the lab.
