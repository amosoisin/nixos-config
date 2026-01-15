{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/system/common.nix
    ../../modules/system/zsh-system.nix
    ./default.nix
  ];
}
