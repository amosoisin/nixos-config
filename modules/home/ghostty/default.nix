{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.ghostty
  ];

  # Ghostty設定ファイルを~/.config/ghostty/configに配置
  # 必要に応じて設定ファイルを追加できます
  # home.file.".config/ghostty/config" = {
  #   text = ''
  #     # Ghostty設定例
  #     # font-family = "JetBrains Mono"
  #     # font-size = 12
  #     # theme = "dark"
  #   '';
  # };
}
