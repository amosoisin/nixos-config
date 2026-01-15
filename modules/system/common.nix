{ config, lib, pkgs, ... }:

{
  # Nix実験的機能の有効化
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # タイムゾーン設定
  time.timeZone = "Asia/Tokyo";

  # ロケール設定
  i18n.defaultLocale = "ja_JP.UTF-8";

  # Docker有効化
  virtualisation.docker.enable = true;

  # システム共通パッケージ
  environment.systemPackages = with pkgs; [
    zsh  # ログインシェルとしてシステムレベルで必要
    git  # システムレベルで必要
  ];

  # Unfreeパッケージ許可
  nixpkgs.config.allowUnfree = true;
}
