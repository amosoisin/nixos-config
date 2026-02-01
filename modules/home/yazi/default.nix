{ config, pkgs, lib, inputs, ... }:

{
  # ===== yaziパッケージ =====
  home.packages = with pkgs; [
    yazi
  ];

  # ===== yazi設定 =====
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    # ===== プラグイン設定 =====
    plugins = {
      # 公式プラグイン（yazi-rs/plugins）
      full-border = "${inputs.yazi-plugins}/full-border.yazi";
      jump-to-char = "${inputs.yazi-plugins}/jump-to-char.yazi";
      # smart-enter = "${inputs.yazi-plugins}/smart-enter.yazi";
      # smart-filter = "${inputs.yazi-plugins}/smart-filter.yazi";

      # サードパーティプラグイン
      bookmarks = inputs.yazi-bookmarks;
      smart-tab = inputs.yazi-smart-tab;
    };

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

    initLua = ''
      require("full-border"):setup {
        -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
        type = ui.Border.ROUNDED,
      }

      require("bookmarks"):setup({
        -- 既定は "none"。永続化を有効にする:
        persist = "all",            -- 推奨："all"（保存・ジャンプ等すべてを永続）
        -- 必要に応じて表示なども調整
        desc_format = "parent",
        custom_desc_input = true,
        show_keys = true,
        file_pick_mode = "parent",
        notify = {
          enable = false,
        },

        -- 直前のディレクトリへの戻り（' マーク）を使うなら:
        last_directory = {
          enable = true,
          persist = true,           -- これも永続化したい場合
          mode = "dir",             -- "dir" | "jump" | "mark"
        },
      })
    '';

    # キーマップ設定（基本的なVimライクな操作 + プラグイン）
    keymap = {
      mgr.prepend_keymap = [
        # 基本操作
        {
          on = [ "d" "d" ];
          run = "remove";
          desc = "Trash seleted files";
        }

        # bookmarks.yazi - ブックマーク機能
        {
          on = [ "m" ];
          run = "plugin bookmarks save";
          desc = "Save current position as a bookmark";
        }
        {
          on = [ "'" ];
          run = "plugin bookmarks jump";
          desc = "Jump to a bookmark";
        }
        {
          on = [ "b" "d" ];
          run = "plugin bookmarks delete";
          desc = "Delete a bookmark";
        }
        {
          on = [ "b" "D" ];
          run = "plugin bookmarks delete_all";
          desc = "Delete all bookmarks";
        }

        # jump-to-char.yazi - 文字ジャンプ
        {
          on = [ "f" ];
          run = "plugin jump-to-char";
          desc = "Jump to char";
        }

        # smart-enter.yazi - 賢いEnter動作
        # {
        #   on = [ "<Enter>" ];
        #   run = "plugin smart-enter";
        #   desc = "Smart enter (open file or enter directory)";
        # }

        # smart-filter.yazi - 賢いフィルター
        # {
        #   on = [ "/" ];
        #   run = "plugin smart-filter";
        #   desc = "Smart filter";
        # }

        # smart-tab.yazi - タブ作成とディレクトリ移動
        {
          on = [ "t" ];
          run = "plugin smart-tab";
          desc = "Create a new tab and enter the directory or open file";
        }
      ];
    };
  };
}
