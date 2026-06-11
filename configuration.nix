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

  programs.zsh = {
    enable = true;
    # ohMyZsh設定はhome-managerで管理
  };

  # Nix実験的機能の有効化
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # タイムゾーン設定
  time.timeZone = "Asia/Tokyo";

  # ロケール設定
  i18n.defaultLocale = "ja_JP.UTF-8";

  # Docker有効化
  virtualisation.docker.enable = true;

  # Unfreeパッケージ許可
  nixpkgs.config.allowUnfree = true;
}
