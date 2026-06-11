{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    vimAlias = true;
  };
}
