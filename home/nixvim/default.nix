{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    vimAlias = true;

    globals = {
      mapleader = " ";
    };

    # =========================
    # Vim options (vim.opt)
    # =========================
    opts = {
      # 一般
      smarttab = true;


      hlsearch = true;
      wrapscan = true;
      ignorecase = true;
      smartcase = true;
      incsearch = true;

      backup = false;
      swapfile = false;
      undofile = true;
      autoread = true;

      hidden = true;
      showcmd = true;

      mouse = "";

      # UI
      signcolumn = "yes";

      # ウィンドウ分割
      splitright = true;
      splitbelow = true;


      # スクロール
      scrolloff = 8;
      sidescrolloff = 8;

      # ファイル
      fileformats = [ "unix" "dos" "mac" ];
      fileencodings = [ "utf-8" "sjis" "euc-jp" "default" ];

      # スペルチェック
      spell = true;
      spelllang = [ "en" "cjk" ];

      # 行番号 (相対番号)
      number = true;
      relativenumber = true;

      # GUIカラー有効
      termguicolors = true;

      # 不可視文字の表示
      list = true;
      listchars = builtins.concatStringsSep "," [
        "tab:»-"
        "trail:-"

        "eol:↲"
        "extends:»"
        "precedes:«"

        "nbsp:%"
      ];

      laststatus = 3;
    };

    keymaps = [
      # コロンとセミコロン入れ替え
      {
        mode = "n";
        key = ":";
        action = ";";
        options = { noremap = true; silent = true; };
      }
      {
        mode = "n";
        key = ";";
        action = ":";
        options = { noremap = true; silent = true; };

      }

      # ハイライト解除（Esc Esc）
      {
        mode = "n";
        key = "<Esc><Esc>";
        action = "<Cmd>nohlsearch<CR>";
        options = { noremap = true; silent = true; };
      }

      # バッファ移動
      {
        mode = "n";
        key = "<C-h>";
        action = "<Cmd>bprevious<CR>";
        options = { noremap = true; silent = true; };
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<Cmd>bnext<CR>";
        options = { noremap = true; silent = true; };
      }
    ];

    plugins.lualine.enable = true;

    # =========================
    # Luaでしか書けない部分
    # =========================
    extraConfigLua = ''
      -- ファイルタイプ設定の自動コマンド
      vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = "*.htm",

        command = "setfiletype html",
      })
    '';
  };
}
