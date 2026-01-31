{ config, pkgs, lib, ... }:

{
  # ===== yaziパッケージ =====
  home.packages = with pkgs; [
    yazi
  ];

  # ===== yazi設定 =====
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      mgr = {
        # ファイルマネージャーの表示設定
        show_hidden = true;
        show_symlink = true;
        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        linemode = "size";
      };

      preview = {
        # プレビュー設定
        tab_size = 2;
        max_width = 600;
        max_height = 900;
      };
    };

    # キーマップ設定（基本的なVimライクな操作）
    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "d" "d" ];
          run = "remove";
          desc = "Trash seleted files";
        }
      ];
    };
  };
}
