# NixOS-WSL Configuration

NixOS-WSL環境向けのNixOS設定リポジトリです。Nix Flakesとhome-managerを使用した最新の設定管理アプローチを採用しています。

## 特徴

- **WSL2特化** - Windows WSL2環境向けに最適化
- **Flakes採用** - 再現性の高い最新のNix管理方式
- **開発環境充実** - Go, Rust, Python, Node.js対応
- **LSP完備** - 主要言語のLanguage Server統合
- **日本語対応** - タイムゾーン・ロケール設定済み
- **Modern CLI** - Rust製高速ツール採用（ripgrep, fd, eza, bat等）

## ディレクトリ構成

```
nixos-config/
├── flake.nix             # Flakesメイン設定
├── flake.lock            # 依存関係ロックファイル
├── .gitmodules           # Gitサブモジュール設定
├── configuration.nix     # NixOSシステム設定
├── home.nix              # home-manager設定（ユーザー環境）
├── claude/               # Claude Code関連設定
│   └── claude.nix        # Claudeモジュール設定
├── git/                  # Git関連設定
│   └── git.nix           # Gitモジュール設定
├── zsh/                  # Zsh関連設定
│   ├── zsh.nix           # Zshモジュール設定（プラグイン等）
│   └── p10k.zsh          # Powerlevel10k設定
├── tmux/                 # tmux関連設定
│   └── tmux.nix          # tmuxモジュール設定
└── neovim/               # Neovim関連設定
    ├── README.md         # Neovim設定の仕組み解説
    ├── neovim.nix        # Neovimモジュール設定
    └── nvim.lua/         # Neovim設定ファイル（Gitサブモジュール）
```

## 前提条件

- Windows 10/11 with WSL2
- NixOS-WSL がインストール済み

## セットアップ

1. NixOS-WSL環境にこのリポジトリをクローン（サブモジュールも含む）：

```bash
git clone --recursive <repository-url> ~/nixos-config
cd ~/nixos-config
```

または、既にクローンしている場合はサブモジュールを初期化：

```bash
git submodule update --init --recursive
```

2. 設定を適用：

```bash
sudo nixos-rebuild switch --flake .
```

## 主要コンポーネント

### システム設定（configuration.nix）

| 設定項目 | 値 |
|---------|-----|
| タイムゾーン | Asia/Tokyo |
| ロケール | ja_JP.UTF-8 |
| Docker | 有効 |
| デフォルトシェル | Zsh |
| Windows相互運用 | 有効（PATHも含める） |

### インストールされるパッケージ

#### エディタ
- Neovim, Vim

#### プログラミング言語
- Go, Python3, Node.js 22, Rust (rustup)

#### LSPサーバー
- clangd (C/C++)
- pyright (Python)
- bash-language-server
- lua-language-server
- typescript-language-server
- rust-analyzer

#### CLIツール
| ツール | 説明 |
|--------|------|
| ripgrep | 高速テキスト検索 |
| fd | 高速ファイル検索 |
| eza | モダンなls |
| bat | 構文ハイライト付きcat |
| fzf | ファジーファインダー |
| zoxide | スマートディレクトリジャンプ |
| lazygit | Git TUI |
| tmux | ターミナルマルチプレクサ |

### Git設定

- **ユーザー設定の自動生成**: 初回ログイン時に`~/.gitconfig-user`を対話的に作成
- **プライバシー保護**: user.name/emailはリポジトリにコミットされない
- **エディタ**: Neovim
- **エイリアス**: `s`(status), `g`(log --graph), `difff`(diff --word-diff), `cm`(commit)

### Zsh設定

- **テーマ**: Powerlevel10k（レインボーカラー）
- **プラグイン管理**: oh-my-zsh
- **主要プラグイン**: git, docker, fzf, zoxide, you-should-use, fzf-tab, forgit
- **Gitユーザー設定**: 初回ログイン時に`~/.gitconfig-user`を自動生成
- **tmux自動起動**: ログイン時に`dev`セッションを自動起動/アタッチ

### tmux設定

- **プレフィックスキー**: `Ctrl-a`
- **ウィンドウ分割**: `|`（横）, `-`（縦）
- **ペイン移動**: `h,j,k,l`（Vimスタイル）
- **プラグイン**: sensible, yank, resurrect, continuum

### Neovim設定

- **設定ファイル**: Gitサブモジュール（neovim/nvim.lua、元リポジトリ：amosoisin/nvim.lua）から`~/.config/nvim`に配置
- **プラグイン管理**: lazy.nvim
- **デフォルトエディタ**: 有効（EDITOR, VISUAL環境変数を自動設定）
- **エイリアス**: vi, vim, vimdiff → nvim
- **Python3サポート**: 有効（pynvim統合）
- **LSPサーバー**: clangd, pyright, bash-language-server, lua-language-server, typescript-language-server等

### Claude Code設定

- **インストール元**: nixpkgs-unstable（常に最新バージョンを取得）
- **設定ファイル**: `claude/claude.nix`

## よく使うコマンド

```bash
# 設定を適用
nrs   # sudo nixos-rebuild switch --flake .

# 設定をテスト（再起動なし）
nrt   # sudo nixos-rebuild test --flake .

# Flakesを更新
nfu   # nix flake update

# パッケージ検索
nse   # nix search nixpkgs
```

## 依存関係

| コンポーネント | ブランチ/リポジトリ |
|--------------|---------|
| nixpkgs | nixos-25.05 |
| nixpkgs-unstable | nixos-unstable（最新パッケージ用） |
| home-manager | release-25.05 |
| NixOS-WSL | release-25.05 |
| nvim-config | ローカルサブモジュール（元リポジトリ：github:amosoisin/nvim.lua） |

## カスタマイズ

### パッケージの追加

`home.nix`の`home.packages`にパッケージを追加：

```nix
home.packages = with pkgs; [
  # 既存のパッケージ...
  your-new-package
];
```

### Zshプラグインの追加

`zsh/zsh.nix`の`plugins`リストにプラグインを追加：

```nix
plugins = [
  # 既存のプラグイン...
  {
    name = "plugin-name";
    src = pkgs.zsh-plugin-name;
    file = "share/zsh/plugins/plugin-name/plugin.zsh";
  }
];
```

### Neovim設定の変更

Neovim設定ファイルはGitサブモジュール（neovim/nvim.lua）として管理されています。

**設定ファイル（nvim.lua）を更新するには**：

```bash
# サブモジュールを最新版に更新
cd neovim/nvim.lua
git pull origin main
cd ../..

# または、リポジトリルートから
git submodule update --remote neovim/nvim.lua

# 設定を適用
nrs
```

**LSPサーバーを追加する場合**は`neovim/neovim.nix`を編集：

```nix
programs.neovim = {
  enable = true;
  extraPackages = with pkgs; [
    # 既存のLSP...
    your-lsp-server
  ];
};
```

**サブモジュールの管理**：
```bash
# サブモジュールの状態確認
git submodule status

# サブモジュールを特定のコミットに固定
cd neovim/nvim.lua
git checkout <commit-hash>
cd ../..
git add neovim/nvim.lua
git commit -m "fix: pin nvim.lua to specific version"
```

## ライセンス

MIT License
