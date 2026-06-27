{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;

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


      {
        mode = "i";
        key = "<C-l>";
        action = "<cmd>lua require('in-and-out').in_and_out()<CR>";
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

      -- tabset.nvim: ファイルタイプごとのタブ設定（guess-indentが既存ファイルを上書き）
      require("tabset").setup({
        defaults = {
          tabwidth = 4,
          expandtab = true,
        },
        languages = {
          {
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "html", "css", "scss" },
            config = {
              tabwidth = 2,
              expandtab = true,
            },
          },
          {
            filetypes = { "lua", "nix" },
            config = {
              tabwidth = 2,
              expandtab = true,
            },
          },
          {
            filetypes = { "go" },
            config = {
              tabwidth = 4,
              expandtab = false,
            },
          },
          {
            filetypes = { "python", "rust", "c", "cpp" },
            config = {
              tabwidth = 4,
              expandtab = true,
            },
          },
        },
      })
    '';

    colorschemes = {
      catppuccin = {
        enable = true;

        settings = {
          flavour = "macchiato";
        };
      };
    };

    plugins = {
      lsp = {
        enable = true;
        keymaps = {
          diagnostic = {
            "gK" = "open_float";
          };
          lspBuf = {
            "K" = "hover";
            "gd" = "definition";
            "gn" = "rename";
            "ga" = "code_action";

            "gr" = "references";

          };
        };

        servers = {
          clangd = { enable = true; };
          bashls = { enable = true; };
          autotools_ls = { enable = true; };
          docker_language_server = { enable = true; };
          luals = { enable = true; };
          pyright = { enable = true; };
          rust_analyzer = {
            enable = true;
            installRustc = true;
            installCargo = true;
          };
          ts_ls = { enable = true; };
        };
      };

      cmp = {
        enable = true;
        settings = {
          sources = [
            {
              name = "nvim_lsp";

              priority = 1000;
            }
          ];
          mapping = {
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(),{'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(),{'i', 's'})";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
          };
        };
      };

      telescope = {
        enable = true;
        settings = {
          defaults = {
            file_ignore_patterns = [
              # .gitディレクトリを除外
              "^.git/"
            ];
          };
          pickers = {
            find_files = {
              # 隠しファイルを表示する
              hidden = true;
            };
          };
        };

        keymaps = {
          "<leader>fg" = {
            action = "live_grep";
          };
          "<leader>ff" = {
            action = "find_files";
          };
          "<leader>fr" = {
            action = "oldfiles";
          };
          "<leader>fb" = {
            action = "buffers";
          };
          "<leader>fh" = {
            action = "help_tags";
          };
        };
      };

      # ぱんくずリスト
      barbecue = { enable = true; };

      # 自動括弧
      nvim-autopairs = { enable = true; };

      # 括弧、タグの編集
      nvim-surround = {
        enable = true;
        # settings = {
        #   keymaps =   {
        #     insert = "<C-g>s";
        #     insert_line = "<C-g>S";
        #     normal = "ys";
        #     normal_cur = "yss";
        #     normal_line = "yS";
        #     normal_cur_line = "ySS";
        #     visual = "S";
        #     visual_line = "gS";
        #     delete = "ds";
        #     change = "cs";
        #     change_line = "cS";
        #   };
        # };
      };

      # Git
      gitsigns = { enable = true; };

      # key
      which-key = { enable = true; };

      # ファイラ
      neo-tree = { enable = true; };

      # インデントを推測
      guess-indent = { enable = true; };

      indent-blankline = { enable = true; };

      # ポップアップ通知
      noice = {
        enable = true;
        settings = {
          presets = {
            bottom_search = true;
            command_palette = true;
            inc_rename = false;
            long_message_to_split = true;
            lsp_doc_border = false;
          };
        };
      };

      incline = { enable = true; };

      marks = { enable = true; };
      # eyeliner = { enable = true; };

      rainbow-delimiters = { enable = true; };

      bufferline = { enable = true; };
      neoscroll = { enable = true; };
      hardtime = { enable = true; };
      better-escape = { enable = true; };
      render-markdown = { enable = true; };

      # depends
      web-devicons = { enable = true; };
      treesitter = { enable = true; };
    };

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "in-and-out";
        src = pkgs.fetchFromGitHub {
          owner = "ysmb-wtsg";
          repo = "in-and-out.nvim";
          rev = "03456b9c49365a28732378a7f2a72a613154e042";
          hash = "sha256-QPEvWOTKzscUs+vHQ0LJ/BNBd9buMgG/jkmjg7JlhT8=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "tabset-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "FotiadisM";
          repo = "tabset.nvim";
          rev = "996f95e4105d053a163437e19a40bd2ea10abeb2";
          hash = "sha256-kOLN74p5AvZlmZRd2hT5c1uV7qziVcyIB8fpC1RiDPk=";
        };
      })
    ];
  };
}
