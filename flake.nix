{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    agenix = {
      url = "github:ryantm/agenix/0.13.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, agenix, ... }@attrs: {
    nixosConfigurations.nixos-meetup-gcloud = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./nixos-meetup-gcloud/hardware-configuration.nix
        ({ config, ... }: { networking.hostName = "nixos-meetup-gcloud"; })
        ./configuration.nix
      ];
    };
    nixosConfigurations.nixos-meetup = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./nixos-meetup/hardware-configuration.nix
        ({ config, ... }: { networking.hostName = "nixos-meetup"; })
        ./configuration.nix
      ];
    };
  };
}
