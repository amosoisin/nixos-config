{ config, lib, pkgs, ... }:

{
  # ===== WSL固有設定 =====
  wsl = {
    enable = true;
    defaultUser = "nixos";
    useWindowsDriver = true;

    wslConf = {
      automount.options = "metadata,umask=022,fmask=011";
    };

    interop = {
      register = true;
      includePath = true;
    };
  };

  # ===== ユーザー定義 =====
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "docker" ];
    shell = pkgs.zsh;
  };

  # ===== State Version =====
  system.stateVersion = "25.05";
}
