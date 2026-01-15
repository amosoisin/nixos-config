{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    # ohMyZsh設定はhome-managerで管理
  };
}
