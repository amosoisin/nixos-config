{ config, pkgs, lib, inputs, pkgs-unstable, ... }:

{
  imports = [ ../../modules/home ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
}
