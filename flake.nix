{
  description = "A very basic flake";

  inputs = {
    nixos-wsl.url = "github:nix-community/NixOS-WSL/release-25.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, nixos-wsl, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        nixos-wsl.nixosModules.default
          {
            system.stateVersion = "25.05";
            wsl.enable = true;
          }
      ];
    };
  };
}
