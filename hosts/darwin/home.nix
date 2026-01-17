{ config, pkgs, lib, inputs, pkgs-unstable, ... }:

{
  imports = [ ../../modules/home ];

  # macOS用ユーザー設定（modules/home/default.nixの値をオーバーライド）
  home.username = "amosoisin";
  home.homeDirectory = "/Users/amosoisin";
  home.stateVersion = "25.05";
}
