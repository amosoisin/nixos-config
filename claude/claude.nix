{ pkgs-unstable, ... }:

{
  home.packages = [
    # nixpkgs-unstableから最新のclaude-codeをインストール
    pkgs-unstable.claude-code
  ];
}
