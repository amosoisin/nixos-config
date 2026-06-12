{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/release-26.05";

    # home-manager
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NixVim
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixvim.inputs.nixpkgs.follows = "nixpkgs";
    };

    # yaziプラグイン（公式リポジトリ）
    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };

    # yaziプラグイン（サードパーティ）
    yazi-bookmarks = {
      url = "github:dedukun/bookmarks.yazi";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, nixvim, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./network.nix
          ./mount.nix
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

            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.nixos = {
              imports = [
                ./home/default.nix
                nixvim.homeModules.nixvim
              ];
            };
          }
        ];
      };
    };
  };
}
