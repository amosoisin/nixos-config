# 概要

## プロジェクト構成

```
nixos-config/
├── flake.nix                         # Flakesメイン設定（入力・出力定義）
├── flake.lock                        # 依存関係ロックファイル
├── .gitmodules                       # Gitサブモジュール設定
├── .gitignore                        # Git除外設定
├── README.md                         # プロジェクト概要・セットアップ手順
├── CLAUDE.md                         # このファイル（アーキテクチャ・設計判断）
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
│   │   └── ghostty/default.nix      # Ghosttyターミナルエミュレータ設定
│   └── system/                       # NixOSシステム共通設定
│       ├── common.nix                # timezone, locale, docker, nix設定
│       └── zsh-system.nix            # システムレベルzsh有効化
│
└── hosts/                            # 環境固有設定
    └── nixos-wsl/                    # NixOS-WSL固有設定
        ├── default.nix               # WSL固有設定（wslブロック、ユーザー、stateVersion）
        ├── configuration.nix         # システムモジュール統合
        └── home.nix                  # ユーザー環境モジュール統合
```

## ファイルの役割

### flake.nix
- **入力**: nixpkgs, home-manager, nixos-wsl（すべてrelease-25.05）、nixpkgs-unstable（最新パッケージ用）、nvim-config（ローカルサブモジュール）
- **出力**: `nixosConfigurations.nixos`（NixOS-WSL用設定）
- 環境ごとの構成を`hosts/`以下から参照
- `pkgs-unstable`を定義し、最新パッケージが必要なモジュール（claudeなど）に渡す

### modules/system/
システムレベルの共通設定（NixOS環境で使用）

- **common.nix**: 全環境共通のシステム設定
  - タイムゾーン（Asia/Tokyo）、ロケール（ja_JP.UTF-8）
  - Docker有効化、Nix実験的機能（flakes, nix-command）
  - nixpkgs設定（allowUnfree）

- **zsh-system.nix**: システムレベルのZsh有効化（`programs.zsh.enable = true`）

### modules/home/
ユーザー環境の共通設定（OS非依存、NixOSとmacOSで共用可能）

- **default.nix**: home-manager統合ファイル
  - `home.username`, `home.homeDirectory`, `home.stateVersion`
  - 全環境共通パッケージ（ripgrep, fd, eza, bat, lazygit等）
  - プログラム設定（fzf, zoxide, bat, eza）
  - 各モジュールのインポート

- **git/**: Gitモジュール設定
  - エイリアス（`s`, `g`, `difff`, `cm`）、エディタ（nvim）、グローバルignore
  - ユーザー固有設定（name, email）は`~/.gitconfig-user`でinclude
  - `~/.gitconfig-user`は初回ログイン時に対話的に自動生成

- **zsh/**: Zshモジュール設定
  - oh-my-zshプラグイン管理、Powerlevel10kテーマ
  - Gitユーザー設定自動生成、tmux自動起動
  - `p10k.zsh`: Powerlevel10kプロンプト設定

- **tmux/**: tmuxモジュール設定
  - プレフィックスキー（`Ctrl-a`）、プラグイン（sensible, yank, resurrect, continuum）
  - キーバインド（ウィンドウ分割、ペイン移動）

- **neovim/**: Neovimモジュール設定
  - LSPサーバー（clangd, pyright, bash-language-server等）
  - エイリアス（vi, vim, vimdiff → nvim）、Python3サポート
  - `nvim.lua/`: Neovim設定ファイル（Gitサブモジュール、https://github.com/amosoisin/nvim.lua）
  - サブモジュールから`~/.config/nvim`に配置

- **claude/**: Claude Codeモジュール設定
  - nixpkgs-unstableから最新のclaude-codeをインストール
  - 安定版nixpkgsでは古いバージョンになるため、unstableを使用
  - `CLAUDE.md`: Claude設定ドキュメント

- **ghostty/**: Ghosttyターミナルエミュレータ設定
  - 必要に応じて設定ファイル（`~/.config/ghostty/config`）を配置可能

### hosts/nixos-wsl/
NixOS-WSL環境固有の設定

- **default.nix**: WSL固有設定
  - wslブロック（Windows相互運用性、systemd有効化）
  - ユーザー定義（nixosユーザー、グループ設定）
  - `system.stateVersion = "25.05"`

- **configuration.nix**: システムモジュール統合
  - `modules/system/common.nix`をインポート
  - `modules/system/zsh-system.nix`をインポート
  - `./default.nix`（WSL固有設定）をインポート

- **home.nix**: ユーザー環境モジュール統合
  - `modules/home/`をインポート（全モジュールを一括取り込み）

## 編集時の注意事項

### Nix構文
- 属性セットは`{ key = value; }`形式（セミコロン必須）
- リストは`[ item1 item2 ]`形式
- 文字列は`"string"`または`''multi-line''`
- パス参照は`./relative/path`

### 設定変更時の確認事項
1. **flake.nix**: 入力の追加・変更時は`nix flake update`が必要
2. **modules/system/**: システム設定変更後は`sudo nixos-rebuild switch`
3. **modules/home/**: パッケージ・プログラム設定変更後は`sudo nixos-rebuild switch`
4. **hosts/nixos-wsl/**: WSL固有設定変更後は`sudo nixos-rebuild switch`

### 新しい環境の追加方法（例: macOS）
複数環境対応のため、モジュールベースの構造を採用しています。新しい環境（macOS等）を追加する手順：

1. **`hosts/darwin/`ディレクトリを作成**
   ```bash
   mkdir -p hosts/darwin
   ```

2. **`hosts/darwin/default.nix`にmacOS固有設定を記述**
   ```nix
   { config, pkgs, ... }:
   {
     # macOS固有設定（Homebrew、macOS特有の設定等）
     system.stateVersion = 5;

     # macOSのシステム設定
     system.defaults = {
       dock.autohide = true;
       # ...
     };
   }
   ```

3. **`hosts/darwin/configuration.nix`でシステムモジュールを統合**
   ```nix
   { config, lib, pkgs, ... }:
   {
     imports = [
       # modules/system/はNixOS専用のため、macOSでは使用しない
       # macOS用の代替モジュールを用意するか、直接設定を記述
       ./default.nix
     ];
   }
   ```

4. **`hosts/darwin/home.nix`でユーザー環境モジュールを統合**
   ```nix
   { config, pkgs, lib, inputs, pkgs-unstable, ... }:
   {
     # modules/home/は完全にOS非依存なので、そのまま再利用可能
     imports = [ ../../modules/home ];
   }
   ```

5. **`flake.nix`に`darwinConfigurations`を追加**
   ```nix
   inputs.darwin.url = "github:lnl7/nix-darwin";

   outputs = { self, nixpkgs, home-manager, nixos-wsl, darwin, ... }:
   {
     # 既存のNixOS設定...
     nixosConfigurations.nixos = { ... };

     # macOS設定を追加
     darwinConfigurations.macbook = darwin.lib.darwinSystem {
       system = "aarch64-darwin";
       modules = [
         ./hosts/darwin/configuration.nix
         home-manager.darwinModules.home-manager
         {
           home-manager.users.username = import ./hosts/darwin/home.nix;
         }
       ];
     };
   };
   ```

6. **共通設定の再利用性**
   - `modules/home/`: **100%そのまま使用可能**（git, zsh, tmux, neovim, claude, ghostty）
   - `modules/system/zsh-system.nix`: そのまま使用可能
   - `modules/system/common.nix`: 一部（timezone, locale）のみ使用可能（Docker等はNixOS専用）

### Gitサブモジュールの管理
- **初回クローン時**: `git clone --recursive` または `git submodule update --init --recursive`
- **サブモジュール更新**: `git submodule update --remote` でリモートの最新版を取得
- **neovim/nvim.lua**: Neovim設定をサブモジュールとして管理（https://github.com/amosoisin/nvim.lua）

### パッケージ検索
パッケージ名を調べるには：
- [search.nixos.org](https://search.nixos.org/packages)
- `nix search nixpkgs パッケージ名`

## 主要設定値

| 項目 | 値 |
|------|-----|
| ユーザー名 | nixos |
| ホームディレクトリ | /home/nixos |
| シェル | Zsh |
| エディタ | Neovim |
| タイムゾーン | Asia/Tokyo |
| ロケール | ja_JP.UTF-8 |
| State version | 25.05 |

## コマンドリファレンス

### NixOS管理（エイリアス）
```bash
nrs   # sudo nixos-rebuild switch --flake .  （設定適用）
nrt   # sudo nixos-rebuild test --flake .    （テスト）
nrb   # sudo nixos-rebuild boot --flake .    （次回起動時反映）
nfu   # nix flake update                      （Flakes更新）
nse   # nix search nixpkgs                    （パッケージ検索）
```

### 開発関連
```bash
lg    # lazygit（Git TUI）
v     # nvim（Neovim起動）
```

# 注意事項
ソースコードの変更を実施した場合は、ドキュメント@CLAUDE.md、@README.mdも変更すること
