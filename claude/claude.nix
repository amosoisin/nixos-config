{ pkgs-unstable, ... }:

{
  home.packages = [
    # nixpkgs-unstableから最新のclaude-codeをインストール
    pkgs-unstable.claude-code
  ];

  # 汎用的なCLAUDE.mdを~/.claude/に配置
  home.file.".claude/CLAUDE.md" = {
    source = ./CLAUDE.md;
  };
}
