{ config, pkgs, lib, inputs, ... }:

{
  # ===== yazi設定 =====
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    # ===== プラグイン設定 =====
    plugins = {
      # 公式プラグイン（yazi-rs/plugins）
      # ボーダー表示
      full-border = "${inputs.yazi-plugins}/full-border.yazi";
      # smart-enter (ファイルならopen、ディレクトリなら移動する)
      smart-enter = "${inputs.yazi-plugins}/smart-enter.yazi";

      # サードパーティプラグイン
      # ブックマークプラグイン
      bookmarks = inputs.yazi-bookmarks;
    };

    settings = {
      mgr = {
        # ファイルマネージャーの表示設定
        show_hidden = false;
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

      opener = {
        # Enter 相当: 既定の「開く」
        open = [
          {
            run = "wslview $@";
            desc = "Open";
            orphan = true;
            for = "linux";
          }
        ];

        # p: メディアを mpv で再生
        play = [
          {
            run = "wslview $@";
            desc = "Play";
            orphan = true;
            for = "linux";
          }
        ];

        # R: システムのファイラで選択を表示
        reveal = [
          {
            run = "wslview $@";
            desc = "Reveal";
            orphan = true;
            for = "linux";
          }
        ];
      };

      open = {
        prepend_rules = [
          { url = "*.drawio"; use = [ "open" "reveal" ]; }
        ];
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
        {
          on = [ "D" "D" ];
          run = "remove --permanently";
          desc = "Permanently delete selected files";
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

        # smart-enter.yazi - 賢いEnter動作
        {
          on = [ "<Enter>" ];
          run = "plugin smart-enter";
          desc = "Smart enter (open file or enter directory)";
        }

        # カスタム設定
        # lazygitを呼び出す
        {
          on = [ "g" "i" "l" ];
          run = "shell --block lazygit";
          desc = "Run lazygit";
        }
        {
          on = [ "g" "i" "w" ];
          run = "shell --block lazygit.exe";
          desc = "Run lazygit.exe (Windows)";
        }

        # 現在ディレクトリをエクスプローラーで開く
        {
          on = [ "e" "c" ];
          run = "shell --orphan \"explorer.exe .\"";
          desc = "Open current Directory as Explorer";
        }

        # テキストコピー系
        {
          on = [ "c" "c" ];
          run = "shell \"get_wsl_path \\\"$@\\\" | win32yank.exe -i\"";
          desc = "Copy file path";
        }
        {
          on = [ "c" "d" ];
          run = "shell \"get_wsl_dir \\\"$@\\\" | win32yank.exe -i\"";
          desc = "Copy the directory path";
        }
        {
          on = [ "c" "f" ];
          run = "shell \"get_wsl_fname \\\"$@\\\" | win32yank.exe -i\"";
          desc = "Copy the filename";
        }
        {
          on = [ "c" "n" ];
          run = "shell \"get_wsl_fname_wo_ext \\\"$@\\\" | win32yank.exe -i\"";
          desc = "Copy the filename without extension";
        }
      ];
    };
  };
}
