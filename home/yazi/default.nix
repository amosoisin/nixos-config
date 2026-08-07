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
      yamb = "${inputs.yamb-yazi}";
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
            run = "wsl-open \"$@\"";
            desc = "Open";
            orphan = true;
            for = "linux";
          }
        ];

        # p: メディアを mpv で再生
        play = [
          {
            run = "wsl-open \"$@\"";
            desc = "Play";
            orphan = true;
            for = "linux";
          }
        ];

        # R: システムのファイラで選択を表示
        reveal = [
          {
            run = "wsl-open \"$@\"";
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

      -- yamb.yazi
      -- You can configure your bookmarks by lua language
      local bookmarks = {}

      require("yamb"):setup {
        -- Optional, the path ending with path seperator represents folder.
        bookmarks = bookmarks,
        -- Optional, recieve notification everytime you jump.
        jump_notify = true,
        -- Optional, the cli of fzf.
        cli = "fzf",
        -- Optional, a string used for randomly generating keys, where the preceding characters have higher priority.

        keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
        -- Optional, the path of bookmarks
        path = (ya.target_family() == "windows" and os.getenv("APPDATA") .. "\\yazi\\config\\bookmark") or
              (os.getenv("HOME") .. "/.config/yazi/bookmark"),
      }
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

        # yamb.yazi - ブックマーク機能
        {
          on = [ "u" "a" ];
          run = "plugin yamb -- save";
          desc = "Add bookmark";
        }
        {
          # on = [ "u" "g" ];
          on = [ ";" ];
          run = "plugin yamb -- jump_by_key";
          desc = "Jump bookmark by key";
        }
        {
          on = [ "u" "G" ];
          run = "plugin yamb -- jump_by_fzf";
          desc = "Jump bookmark by fzf";
        }
        {
          on = [ "u" "d" ];
          run = "plugin yamb -- delete_by_key";
          desc = "Delete bookmark by key";
        }
        # {
        #   on = [ "u" "D" ];
        #   run = "plugin yamb -- delete_by_fzf";
        #   desc = "Delete bookmark by fzf";
        # }
        # {
        #   on = [ "u" "A" ];
        #   run = "plugin yamb -- delete_all";
        #   desc = "Delete all bookmarks";
        # }
        {
          on = [ "u" "r" ];
          run = "plugin yamb -- rename_by_key";
          desc = "Rename bookmark by key";
        }
        {
          on = [ "u" "R" ];
          run = "plugin yamb -- rename_by_fzf";
          desc = "Rename bookmark by fzf";
        }

        # smart-enter.yazi - 賢いEnter動作
        {
          on = [ "<Enter>" ];
          run = "plugin smart-enter";
          desc = "Smart enter (open file or enter directory)";
        }

        # カスタム設定
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
