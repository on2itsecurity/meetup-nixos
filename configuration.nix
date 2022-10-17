{ config, pkgs, agenix, ... }:
{
  imports = [
    agenix.nixosModule
  ];
  
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.shellAliases = {
    downloadMeetup = "curl -L https://github.com/on2itsecurity/meetup-nixos/archive/refs/heads/master.tar.gz | tar zxf - -C /etc/nixos --strip-components=1";
  };

  users.mutableUsers = false;
  users.users.root.hashedPassword = "$6$BIy2JyjhT24ScO66$fPQE6PNRJnhjQUSnj.0i4eT7utBUy2OgUTfvhaVl38JRHcFu/QjZUZuBZxSKOwd2dJ2qpf/2SK/xuuCFMseTA.";
  system.stateVersion = "21.11";
  programs.vim.defaultEditor = true; # remove this line if you want to use nano

  # make your changes below this point
  
}
