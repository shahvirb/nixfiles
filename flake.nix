{
  description = "System configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        argon = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/argon/configuration.nix ];
        };
      };
    };
}