# Edit this configuration file to define what should be installed on your system. Help is available in the configuration.nix(5) man page, on https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository: https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  # WSL用設定
  wsl = {
    enable = true;
    defaultUser = "nixos";
    useWindowsDriver = true;

    wslConf = {
      automount = {
        enabled = true;
        mountFsTab = true;
        options = "metadata,umask=022,fmask=011";
      };
    };

    interop = {
      register = true;
      includePath = true;
    };
  };

  # ===== ユーザー定義 =====
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "docker" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs;[
    git
    neovim
    wget
    zsh
    docker
  ];

  programs.zsh = {
    enable = true;
  };
}
