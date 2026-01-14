{ config, pkgs, lib, ...}:

{
  imports = [
    ./zsh/zsh.nix
    ./tmux/tmux.nix
  ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.packages = with pkgs; [
    # ===== エディタ =====
    neovim
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
    python3Packages.pynvim
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

    # ===== LSPサーバー =====
    clang-tools            # clangd
    pyright
    nodePackages.bash-language-server
    lua-language-server
    nodePackages.typescript-language-server
    nodePackages.typescript
    nodePackages.vim-language-server
    docker-language-server
    autotools-language-server

    # ===== tree-sitter =====
    tree-sitter

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

    # ===== ネットワークツール =====
    nettools
    fping
    iputils

    # ===== Git関連 =====
    gh

    # ===== その他 =====
    tmux
    squashfsTools

    # ==== AI関連 =====
    claude-code
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  # ===== 環境変数 =====
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    LANG = "ja_JP.UTF-8";
  };

  # ===== Git設定 =====
  programs.git = {
    enable = true;
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
  };

}
