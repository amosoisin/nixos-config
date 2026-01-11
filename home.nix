{ config, pkgs, ...}:

{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.packages = with pkgs; [
    nnn
    cowsay
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
