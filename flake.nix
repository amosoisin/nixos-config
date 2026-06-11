{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/release-26.05";

    # home-manager
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./network.nix
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "26.05";
            wsl.enable = true;
          }

          # home-manager設定
          home-manager.nixosModules.home-manager
          {
            # make home-manager as a module of nixos
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.nixos = import ./home/default.nix;
          }
        ];
      };
    };
  };
}
