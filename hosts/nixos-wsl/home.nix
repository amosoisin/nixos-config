{ config, pkgs, lib, inputs, pkgs-unstable, ... }:

{
  imports = [ ../../modules/home ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.packages = with pkgs; [
    nettools
    fping
    iputils
    wslu
  ];
}
