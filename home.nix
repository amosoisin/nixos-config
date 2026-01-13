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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" "kubectl" ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initExtra = ''
      # Powerlevel10k設定ファイルの読み込み
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
    '';
  };
}
