{ config, pkgs, lib, inputs, pkgs-unstable, ... }:

{
  imports = [ ../../modules/home ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.packages = withP pkgs; [
    nettools
    fping
    iputils
  ];
}
