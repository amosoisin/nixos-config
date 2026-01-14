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
├── zsh/                  # Zsh関連設定
│   ├── zsh.nix           # Zshモジュール設定（プラグイン等）
│   └── p10k.zsh          # Powerlevel10k設定
├── tmux/                 # tmux関連設定
│   └── tmux.nix          # tmuxモジュール設定
└── neovim/               # Neovim関連設定
    └── neovim.nix        # Neovimモジュール設定
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
- **tmux自動起動**: ログイン時に`default`セッションを自動起動/アタッチ

### tmux設定

- **プレフィックスキー**: `Ctrl-a`
- **ウィンドウ分割**: `|`（横）, `-`（縦）
- **ペイン移動**: `h,j,k,l`（Vimスタイル）
- **プラグイン**: sensible, yank, resurrect, continuum

### Neovim設定

- **デフォルトエディタ**: 有効（EDITOR, VISUAL環境変数を自動設定）
- **エイリアス**: vi, vim, vimdiff → nvim
- **Python3サポート**: 有効（pynvim統合）
- **LSPサーバー**: clangd, pyright, bash-language-server, lua-language-server, typescript-language-server等

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

`neovim/neovim.nix`でNeovimの設定を変更：

```nix
programs.neovim = {
  enable = true;
  # LSPサーバーを追加
  extraPackages = with pkgs; [
    # 既存のLSP...
    your-lsp-server
  ];
};
```

## ライセンス

MIT License
