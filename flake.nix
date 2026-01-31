{
  description = "A very basic flake";

  inputs = {
    nixos-wsl.url = "github:nix-community/NixOS-WSL/release-25.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.05";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Neovim設定（サブモジュール）
    nvim-config = {
      url = "git+file:./modules/home/neovim/nvim.lua";
      flake = false;
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

    yazi-smart-tab = {
      url = "github:wekauwau/smart-tab.yazi";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-wsl, home-manager, darwin, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/nixos-wsl/configuration.nix

          # wsl-setting
          nixos-wsl.nixosModules.default

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs pkgs-unstable; };
            home-manager.users.nixos = import ./hosts/nixos-wsl/home.nix;
          }
        ];
      };
    };

    darwinConfigurations.darwin = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        inherit inputs;
        pkgs-unstable = import nixpkgs-unstable {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
      };
      modules = [
        ./hosts/darwin/configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            pkgs-unstable = import nixpkgs-unstable {
              system = "aarch64-darwin";
              config.allowUnfree = true;
            };
          };
          home-manager.users.amosoisin = import ./hosts/darwin/home.nix;
        }
      ];
    };
  };
}
