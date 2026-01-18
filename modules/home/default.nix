{ config, pkgs, lib, inputs, pkgs-unstable, ...}:

{
  imports = [
    ./git
    ./zsh
    ./tmux
    (import ./neovim { inherit config pkgs lib inputs; })
    (import ./claude { inherit pkgs-unstable; })
  ];

  home.packages = with pkgs; [
    # ===== エディタ =====
    vim

    # ===== ビルドツール =====
    cmake
    gnumake
    ninja
    automake
    autoconf
    libtool
    pkg-config
    gettext

    # ===== コンパイラ・言語 =====
    gcc
    go
    nodejs_24
    python3
    python3Packages.pip
    luarocks

    # ===== Rust（ツールチェーン） =====
    rustup

    # ===== Rust製ツール =====
    ripgrep
    fd
    eza
    bat
    zoxide

    # ===== Go製ツール =====
    lazygit
    lazydocker
    fzf

    # ===== CLI ユーティリティ =====
    curl
    wget
    unzip
    jq
    tree
    socat
    gnupg
    universal-ctags
    shellcheck

    # ===== Git関連 =====
    gh
    pkgs.delta

    # ===== その他 =====
    tmux
    squashfsTools

    obsidian
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  # ===== 環境変数 =====
  home.sessionVariables = {
    LANG = "ja_JP.UTF-8";
  };

  # ===== fzf設定 =====
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [ "--tmux" ];
  };

  # ===== zoxide設定 =====
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };

  # ===== bat設定 =====
  programs.bat = {
    enable = true;
  };

  # ===== eza設定 =====
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
  };

}
