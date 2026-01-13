{ config, pkgs, ...}:

{
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
    nodejs_22
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
    fzf

    # ===== LSPサーバー =====
    clang-tools            # clangd
    pyright
    nodePackages.bash-language-server
    lua-language-server
    nodePackages.typescript-language-server
    nodePackages.typescript
    nodePackages.vim-language-server
    # rust-analyzer は rustup 経由で管理（env.zsh参照）

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
    nnn
    cowsay
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
  };

  # ===== zoxide設定 =====
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
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

  # ===== tmux設定 =====
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
    ];
    extraConfig = ''
      # マウスサポート
      set -g mouse on

      # プレフィックスキーをC-aに変更
      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix

      # ペイン分割のキーバインド
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Vimスタイルのペイン移動
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # ペインリサイズ
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # ウィンドウ番号を1から開始
      set -g base-index 1
      setw -g pane-base-index 1

      # ウィンドウを閉じた時に番号を詰める
      set -g renumber-windows on
    '';
  };

  # ===== Zsh設定 =====
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "fzf"
        "zoxide"
        "golang"
        "rust"
        "npm"
        "pip"
      ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "forgit";
        src = pkgs.zsh-forgit;
        file = "share/zsh/zsh-forgit/forgit.plugin.zsh";
      }
      {
        name = "my-config";
        src = ./config/zsh;
        file = "my-config.plugin.zsh";
      }
    ];
  };
}
