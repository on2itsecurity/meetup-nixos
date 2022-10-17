# LAB 5 - Managing your dotfiles declaratively *(and more)*

Dotfiles are your unix user configurations files, such as (`.vimrc`, `.config/git/config`)
Login as the `meetup` user you created in LAB1 and use that user for this entire lab (no need to run things as `root`).

## 5.1 Bootstrap home-manager
Bootstrap home-manager by following instructions from this [README](./home/meetup/.config/nixpkgs/README.md)
(This will preinstall a small user profile for `meetup`)

## 5.2 Manage SSH
Note that currently SSH is not installed on the system.
Configure home-manager to install ssh and manage its configuration.

## Answer
<details><summary>Click to show the answer</summary>
<p>
  
```nix
  programs.ssh.enable = true;
```

</p>
</details>

## 5.3 Additional config

Modify the configuration to disable agent forwarding by default. Add a (bogus) host specific configuration that has agent forwarding enabled. This will show you how to manage your SSH configuration using home-manager.

## Answer
<details><summary>Click to show the answer</summary>
<p>
  
```nix
  programs.ssh = {
    enable = true;
    forwardAgent = false;
    matchBlocks = {
      "bogus" = {
        forwardAgent = true;
      };
    };
  };
```

</p>
</details>

Bonus excercise: have home-manager manage your prompt by enabling `starship` and its shell integration.

## End of LAB5
This is the end of the lab.
