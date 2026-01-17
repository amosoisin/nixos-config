# NixOS Configuration

NixOS-WSLとmacOS（nix-darwin）に対応したNix設定リポジトリです。Nix Flakesとhome-managerを使用した最新の設定管理アプローチを採用しています。

## 特徴

- **マルチプラットフォーム** - NixOS-WSL（x86_64-linux）とmacOS（aarch64-darwin、Apple Silicon）に対応
- **設定の共有** - ユーザー環境設定（`modules/home/`）は完全にOS非依存で、両環境で共用可能
- **Flakes採用** - 再現性の高い最新のNix管理方式
- **開発環境充実** - Go, Rust, Python, Node.js対応
- **LSP完備** - 主要言語のLanguage Server統合
- **日本語対応** - タイムゾーン・ロケール設定済み
- **Modern CLI** - Rust製高速ツール採用（ripgrep, fd, eza, bat等）

## ディレクトリ構成

```
nixos-config/
├── flake.nix                         # Flakesメイン設定
├── flake.lock                        # 依存関係ロックファイル
├── .gitmodules                       # Gitサブモジュール設定
├── README.md                         # このファイル
├── CLAUDE.md                         # アーキテクチャ・設計判断
│
├── modules/                          # 再利用可能なモジュール
│   ├── home/                         # home-manager共通設定（OS非依存）
│   │   ├── default.nix              # 共通パッケージ・プログラム統合
│   │   ├── git/default.nix          # Gitモジュール設定
│   │   ├── zsh/                      # Zsh関連設定
│   │   │   ├── default.nix          # Zshモジュール設定（プラグイン等）
│   │   │   └── p10k.zsh             # Powerlevel10kプロンプト設定
│   │   ├── tmux/default.nix         # tmuxモジュール設定
│   │   ├── neovim/                   # Neovim関連設定
│   │   │   ├── default.nix          # Neovimモジュール設定（LSP等）
│   │   │   ├── README.md            # Neovim設定の仕組み解説
│   │   │   └── nvim.lua/            # Neovim設定ファイル（Gitサブモジュール）
│   │   ├── claude/                   # Claude Code関連設定
│   │   │   ├── default.nix          # Claudeモジュール設定（unstable使用）
│   │   │   └── CLAUDE.md            # Claude設定ドキュメント
│   │   └── ghostty/default.nix      # Ghosttyターミナルエミュレータ設定（現在無効化）
│   └── system/                       # NixOSシステム共通設定
│       ├── common.nix                # timezone, locale, docker, nix設定
│       └── zsh-system.nix            # システムレベルzsh有効化
│
└── hosts/                            # 環境固有設定
    ├── nixos-wsl/                    # NixOS-WSL固有設定
    │   ├── default.nix               # WSL固有設定（wslブロック、ユーザー、stateVersion）
    │   ├── configuration.nix         # システムモジュール統合
    │   └── home.nix                  # ユーザー環境モジュール統合
    └── darwin/                       # macOS固有設定
        ├── default.nix               # macOS固有設定（primaryUser、システムデフォルト、stateVersion）
        ├── configuration.nix         # システムモジュール統合
        └── home.nix                  # ユーザー環境モジュール統合
```

この構造により、以下の利点があります：
- **OS非依存のユーザー環境**: `modules/home/`は完全にOS非依存で、NixOSとmacOS（nix-darwin）で共用可能
- **環境固有設定の分離**: WSL、macOS等の環境固有設定は`hosts/`以下に配置
- **保守性向上**: 設定の責務がディレクトリで明確に分離されている
- **拡張性**: 新しい環境の追加が容易

## 対応環境

このリポジトリは以下の環境に対応しています：

| 環境 | プラットフォーム | ホスト名 | ユーザー名 | ホームディレクトリ |
|------|--------------|----------|----------|------------------|
| NixOS-WSL | x86_64-linux | nixos | nixos | /home/nixos |
| macOS (Apple Silicon) | aarch64-darwin | darwin | amosoisin | /Users/amosoisin |

`modules/home/`の設定（Git, Zsh, tmux, Neovim, Claude Code等）は完全にOS非依存で、両環境で共用できます。
**注意**: GhosttyはmacOS環境でbrokenのため現在無効化されています。Linux専用パッケージ（nettools, fping, iputils）はNixOS-WSL環境のみで定義されています。

## 前提条件

### NixOS-WSL環境
- Windows 10/11 with WSL2
- NixOS-WSL がインストール済み

### macOS環境
- macOS（Apple Siliconを推奨）
- Nix package manager がインストール済み
- nix-darwin がインストール済み（後述）

## セットアップ

### NixOS-WSL環境のセットアップ

1. リポジトリをクローン（サブモジュールも含む）：

```bash
git clone --recursive <repository-url> /mnt/c/Users/<your-username>/nixos-config
cd /mnt/c/Users/<your-username>/nixos-config
```

または、既にクローンしている場合はサブモジュールを初期化：

```bash
git submodule update --init --recursive
```

2. 設定を適用：

```bash
sudo nixos-rebuild switch --flake .#nixos
```

**注意**: `#nixos`はflake.nix内で定義された設定名（`nixosConfigurations.nixos`）を指定しています。

### macOS環境のセットアップ

1. Nix package managerをインストール（まだの場合）：

```bash
# 公式インストールスクリプト（マルチユーザーインストール推奨）
sh <(curl -L https://nixos.org/nix/install)
```

2. Homebrewをインストール（まだの場合）：

```bash
# 公式インストールスクリプト
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**重要**: この設定ではnix-darwinのパッケージマネージャー機能を無効化（`nix.enable = false`）し、Homebrewをメインのパッケージマネージャーとして使用します。そのため、nix-darwinをインストールする前にHomebrewのインストールが必要です。

3. nix-darwinをインストール：

```bash
# Nix Flakesを有効化
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# nix-darwinを一時的にインストール
nix run nix-darwin -- switch --flake <repository-url>#darwin
```

4. リポジトリをクローン（サブモジュールも含む）：

```bash
git clone --recursive <repository-url> ~/nixos-config
cd ~/nixos-config
```

5. 設定を適用：

```bash
darwin-rebuild switch --flake .#darwin
```

**注意**: `#darwin`はflake.nix内で定義された設定名（`darwinConfigurations.darwin`）を指定しています。

## 主要コンポーネント

### システム設定

#### NixOS-WSL（configuration.nix）

| 設定項目 | 値 |
|---------|-----|
| タイムゾーン | Asia/Tokyo |
| ロケール | ja_JP.UTF-8 |
| Docker | 有効 |
| デフォルトシェル | Zsh |
| Windows相互運用 | 有効（PATHも含める） |

#### macOS（configuration.nix）

| 設定項目 | 値 |
|---------|-----|
| プライマリユーザー | amosoisin |
| デフォルトシェル | Zsh |
| Dock | 自動非表示有効 |
| キーボード | CapsLock→Control変更 |

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
- **設定ファイル**: `modules/home/claude/default.nix`

### Ghostty設定

- **現在の状態**: macOS環境でbrokenのため無効化
- **設定ファイル**: `modules/home/ghostty/default.nix`（存在するが使用されていない）

## よく使うコマンド

### NixOS-WSL環境

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

### macOS環境

```bash
# 設定を適用
darwin-rebuild switch --flake .#darwin

# Flakesを更新
nix flake update

# パッケージ検索
nix search nixpkgs
```

**共通コマンド**（環境に依存しないエイリアス）：
```bash
# Git（lazygit）
lg

# Neovim
v

# ディレクトリジャンプ
z <directory-name>  # zoxide

# ファジーファインダー
fzf
```

## 依存関係

| コンポーネント | ブランチ/リポジトリ | 備考 |
|--------------|---------|------|
| nixpkgs | nixos-25.05 | 安定版パッケージ |
| nixpkgs-unstable | nixos-unstable | 最新パッケージ用（Claude Code等） |
| home-manager | release-25.05 | ユーザー環境管理 |
| NixOS-WSL | release-25.05 | NixOS-WSL環境のみ |
| nix-darwin | nix-darwin-25.05 | macOS環境のみ |
| nvim-config | ローカルサブモジュール | `modules/home/neovim/nvim.lua`、元リポジトリ：github:amosoisin/nvim.lua |

## カスタマイズ

モジュールベースの構造により、設定の編集場所が明確になっています。

### パッケージの追加

`modules/home/default.nix`の`home.packages`にパッケージを追加：

```nix
home.packages = with pkgs; [
  # 既存のパッケージ...
  your-new-package
];
```

### Zshプラグインの追加

`modules/home/zsh/default.nix`の`plugins`リストにプラグインを追加：

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

### WSL固有設定の変更

`hosts/nixos-wsl/default.nix`でWSL固有の設定を変更：

```nix
{
  wsl = {
    enable = true;
    # WSL設定をカスタマイズ...
  };
}
```

### 新しい環境の追加（例: macOS）

1. `hosts/darwin/`ディレクトリを作成
2. `hosts/darwin/default.nix`にmacOS固有設定を記述（`system.primaryUser`を含む）
3. `hosts/darwin/configuration.nix`でシステムモジュールを統合
4. `hosts/darwin/home.nix`で`modules/home/`をインポート（ユーザー設定を定義）
5. `flake.nix`に`darwinConfigurations`を追加（リリースブランチを明示）

詳細は`CLAUDE.md`の「新しい環境の追加方法」セクションを参照してください。

### Neovim設定の変更

Neovim設定ファイルはGitサブモジュール（modules/home/neovim/nvim.lua）として管理されています。

**設定ファイル（nvim.lua）を更新するには**：

```bash
# サブモジュールを最新版に更新
cd modules/home/neovim/nvim.lua
git pull origin main
cd ../../../..

# または、リポジトリルートから
git submodule update --remote modules/home/neovim/nvim.lua

# 設定を適用
nrs
```

**LSPサーバーを追加する場合**は`modules/home/neovim/default.nix`を編集：

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
cd modules/home/neovim/nvim.lua
git checkout <commit-hash>
cd ../../../..
git add modules/home/neovim/nvim.lua
git commit -m "fix: pin nvim.lua to specific version"
```

## ライセンス

MIT License
