{ config, lib, pkgs, ... }:

{
  imports = [
    ./default.nix
    ../../modules/system/zsh-system.nix
  ];

  # Nix実験的機能の有効化
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Unfreeパッケージ許可
  nixpkgs.config.allowUnfree = true;

  # Homebrew設定
  homebrew = {
    enable = true;
  };

  # システム共通パッケージ
  environment.systemPackages = with pkgs; [
    zsh  # ログインシェルとしてシステムレベルで必要
    git  # システムレベルで必要
  ];
}
