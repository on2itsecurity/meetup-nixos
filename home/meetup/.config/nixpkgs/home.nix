{ config, pkgs, homeage, ... }:
{

  home.username = "meetup";
  home.homeDirectory = "/home/meetup";
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;

  # configuration below here

  home.packages = [
    pkgs.fortune
  ];

  programs.htop.enable = true;

  programs.git = {
    enable = true;
    userName = "User Name";
    userEmail = "meetup@example.com";
    aliases = {
      unstage = "reset HEAD --";
    };
    delta.enable = true;
    delta.options = { features = "decorations"; };
    ignores = [ "*~" "*.swp" ".DS_Store" ];
  };


  programs.bash.enable = true;
  home.shellAliases = {
    downloadMeetupHome = "mkdir -p ~/.config/nixpkgs && pushd ~/.config/nixpkgs && curl -O --silent https://raw.githubusercontent.com/on2itsecurity/meetup-nixos/master/home/meetup/.config/nixpkgs/flake.nix && curl -O --silent https://raw.githubusercontent.com/on2itsecurity/meetup-nixos/master/home/meetup/.config/nixpkgs/home.nix && popd";
  };
  
  ## example user secrets management using homeage (https://github.com/jordanisaacs/homeage)
  ## currently only works on systemd based distro's
  #imports = [ homeage.homeManagerModules.homeage ];  
  #homeage = {
  #  identityPaths = [ "~/.ssh/id_ed25519" ];
  #  file."supersecretkey" = {
  #    source = ./supersecretkey.json.age;
  #    symlinks = [ "${config.xdg.configHome}/supersecretkey.json" ];
  #  };
  #};
}
