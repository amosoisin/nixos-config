{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.claude-code
  ];

  # 汎用的なCLAUDE.mdを~/.claude/に配置
  home.file.".claude/CLAUDE.md" = {
    source = ./CLAUDE.md;
  };
}
