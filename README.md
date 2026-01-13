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
├── configuration.nix     # NixOSシステム設定
├── home.nix              # home-manager設定（ユーザー環境）
└── config/               # カスタム設定ファイル
    └── zsh/
        ├── aliases.zsh          # エイリアス定義
        ├── env.zsh              # 環境変数設定
        ├── functions.zsh        # カスタム関数
        ├── my-config.plugin.zsh # プラグインエントリーポイント
        └── p10k.zsh             # Powerlevel10k設定
```

## 前提条件

- Windows 10/11 with WSL2
- NixOS-WSL がインストール済み

## セットアップ

1. NixOS-WSL環境にこのリポジトリをクローン：

```bash
git clone <repository-url> ~/nixos-config
cd ~/nixos-config
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

### Zsh設定

- **テーマ**: Powerlevel10k（レインボーカラー）
- **プラグイン管理**: oh-my-zsh
- **主要プラグイン**: git, docker, fzf, zoxide, you-should-use, fzf-tab, forgit

### tmux設定

- **プレフィックスキー**: `Ctrl-a`
- **ウィンドウ分割**: `|`（横）, `-`（縦）
- **ペイン移動**: `h,j,k,l`（Vimスタイル）
- **プラグイン**: sensible, yank, resurrect, continuum

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

| コンポーネント | ブランチ |
|--------------|---------|
| nixpkgs | nixos-25.05 |
| home-manager | release-25.05 |
| NixOS-WSL | release-25.05 |

## カスタマイズ

### パッケージの追加

`home.nix`の`home.packages`にパッケージを追加：

```nix
home.packages = with pkgs; [
  # 既存のパッケージ...
  your-new-package
];
```

### エイリアスの追加

`config/zsh/aliases.zsh`にエイリアスを追加：

```bash
alias myalias='my-command'
```

### 環境変数の追加

`config/zsh/env.zsh`に環境変数を追加：

```bash
export MY_VAR="value"
```

## ライセンス

MIT License
