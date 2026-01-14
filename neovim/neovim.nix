{ config, pkgs, lib, ... }:

{
  # ===== Neovim設定 =====
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Python3サポート
    withPython3 = true;

    # 追加パッケージ
    extraPackages = with pkgs; [
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

      # ===== Neovim依存 =====
      python3Packages.pynvim
    ];
  };
}
