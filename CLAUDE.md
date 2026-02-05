# 概要
これはnixの設定ですが、必ずしもNix環境で変更を行っている訳ではないので、
テスト実行時はテスト実行可能環境かどうかを事前に確認してください。

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
│   │   ├── yazi/default.nix         # yaziファイルマネージャー設定
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
    ├── nixos-wsl/                    # NixOS-WSL固有設定
    │   ├── default.nix               # WSL固有設定（wslブロック、ユーザー、stateVersion）
    │   ├── configuration.nix         # システムモジュール統合
    │   └── home.nix                  # ユーザー環境モジュール統合
    └── darwin/                       # macOS固有設定
        ├── default.nix               # macOS固有設定（システム設定、キーボード設定、ユーザー定義）
        ├── configuration.nix         # システムモジュール統合（Homebrew、Nix設定）
        └── home.nix                  # ユーザー環境モジュール統合
```

## ファイルの役割

### flake.nix
- **入力**:
  - nixpkgs, home-manager, nixos-wsl（すべてrelease-25.05）
  - darwin（nix-darwin、nix-darwin-25.05ブランチ）
  - nixpkgs-unstable（最新パッケージ用）
  - nvim-config（ローカルサブモジュール）
  - yazi-plugins（公式プラグインリポジトリ: yazi-rs/plugins）
  - yazi-bookmarks（dedukun/bookmarks.yazi）
  - yazi-smart-tab（wekauwau/smart-tab.yazi）
- **出力**:
  - `nixosConfigurations.nixos`（NixOS-WSL用設定）
  - `darwinConfigurations.darwin`（macOS用設定）
- 環境ごとの構成を`hosts/`以下から参照
- `pkgs-unstable`を定義し、最新パッケージが必要なモジュール（claude、yaziなど）に渡す
- 各環境用に個別の`pkgs-unstable`を定義（x86_64-linux、aarch64-darwin）

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
  - `home.stateVersion`（ユーザー名とホームディレクトリは各環境のhome.nixで個別に定義）
  - 全環境共通パッケージ（ripgrep, fd, eza, bat, lazygit等）
  - プログラム設定（fzf, zoxide, bat, eza）
  - 各モジュールのインポート（git, zsh, tmux, yazi, neovim, claude）

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

- **yazi/**: yaziファイルマネージャーモジュール設定
  - Rust製の高速ターミナルファイルマネージャー
  - nixpkgs-unstableから最新のyaziをインストール（安定版では古いバージョンになる可能性があるため）
  - `programs.yazi.package`でunstable版を指定（競合を避けるため`home.packages`からは削除）
  - Zsh統合（`programs.yazi.enableZshIntegration`）
  - Vimライクなキーバインド（h/l で移動、Enter で開く）
  - ファイルプレビュー機能、シンボリックリンク表示
  - プラグイン統合（bookmarks, full-border, jump-to-char, smart-enter, smart-filter, smart-tab）
    - **bookmarks.yazi** (dedukun): ブックマーク機能（m で保存、' でジャンプ、bd で削除）
    - **full-border.yazi** (公式): フルボーダー表示（`initLua`で`require("full-border"):setup()`を呼び出し）
    - **jump-to-char.yazi** (公式): 文字ジャンプ機能（f キー）
    - **smart-enter.yazi** (公式): 賢いEnter動作（ファイルを開く、ディレクトリに入る）
    - **smart-filter.yazi** (公式): 賢いフィルター機能（/ キー）
    - **smart-tab.yazi** (wekauwau): タブ作成とディレクトリ移動（t キー）
  - **重要**: full-borderプラグインは`plugin.prepend_preloaders`ではなく、`initLua`オプションで初期化すること（詳細はトラブルシューティング参照）

- **neovim/**: Neovimモジュール設定
  - LSPサーバー（clangd, pyright, bash-language-server等）
  - エイリアス（vi, vim, vimdiff → nvim）、Python3サポート
  - `nvim.lua/`: Neovim設定ファイル（Gitサブモジュール、https://github.com/amosoisin/nvim.lua）
  - サブモジュールから`~/.config/nvim`に配置

- **claude/**: Claude Codeモジュール設定
  - nixpkgs-unstableから最新のclaude-codeをインストール
  - 安定版nixpkgsでは古いバージョンになるため、unstableを使用
  - `CLAUDE.md`: Claude設定ドキュメント

- **ghostty/**: Ghosttyターミナルエミュレータ設定（現在無効化）
  - macOS環境でbrokenとマークされているため、現在は使用していない
  - NixOS-WSL環境でのみ利用可能な可能性あり

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
  - NixOS-WSL用ユーザー設定（username: nixos、homeDirectory: /home/nixos）
  - Linux専用パッケージ（nettools, fping, iputils）を追加定義

### hosts/darwin/
macOS環境固有の設定

- **default.nix**: macOS固有設定
  - プライマリユーザー設定（`system.primaryUser = "amosoisin"`、nix-darwin 25.05以降で必須）
  - ユーザー定義（amososinユーザー、/Users/amosoisin）
  - macOSシステム設定（Dock、Finder、トラックパッド、スクリーンセーバー等）
  - NSGlobalDomain設定（ダークモード、キーボードリピート、自動修正無効化等）
  - キーボード設定（CapsLockをControlに変更）
  - スクリーンショット保存設定
  - `system.stateVersion = 5`

- **configuration.nix**: システムモジュール統合
  - `./default.nix`（macOS固有設定）をインポート
  - `modules/system/zsh-system.nix`をインポート（NixOSと共用可能）
  - Nix実験的機能の有効化（flakes, nix-command）
  - nixpkgs設定（allowUnfree）
  - **Nixパッケージマネージャーの無効化**（`nix.enable = false`）：nix-darwinのパッケージ管理機能を無効化し、Homebrewをメインのパッケージマネージャーとして使用
  - Homebrew有効化（**注意**: nix-darwinインストール前に手動でHomebrewをインストールする必要があります）
  - システム共通パッケージ（zsh, git）

- **home.nix**: ユーザー環境モジュール統合
  - `modules/home/`をインポート（NixOSと完全共用）
  - macOS用ユーザー設定（username: amosoisin、homeDirectory: /Users/amosoisin）
  - `home.stateVersion = "25.05"`

## 編集時の注意事項

### Nix構文
- 属性セットは`{ key = value; }`形式（セミコロン必須）
- リストは`[ item1 item2 ]`形式
- 文字列は`"string"`または`''multi-line''`
- パス参照は`./relative/path`

### 設定変更時の確認事項
1. **flake.nix**: 入力の追加・変更時は`nix flake update`が必要
2. **modules/system/**: システム設定変更後は、NixOSでは`sudo nixos-rebuild switch`、macOSでは`darwin-rebuild switch --flake .#darwin`
3. **modules/home/**: パッケージ・プログラム設定変更後は、NixOSでは`sudo nixos-rebuild switch`、macOSでは`darwin-rebuild switch --flake .#darwin`
4. **hosts/nixos-wsl/**: WSL固有設定変更後は`sudo nixos-rebuild switch --flake .#nixos`
5. **hosts/darwin/**: macOS固有設定変更後は`darwin-rebuild switch --flake .#darwin`

### 新しい環境の追加方法（例: macOS）
複数環境対応のため、モジュールベースの構造を採用しています。macOS環境は既に実装されており、`hosts/darwin/`として参照できます。新しい環境を追加する際は、以下の手順を参考にしてください。

#### macOS環境の実装例（`hosts/darwin/`）

1. **`hosts/darwin/`ディレクトリを作成**
   ```bash
   mkdir -p hosts/darwin
   ```

2. **`hosts/darwin/default.nix`にmacOS固有設定を記述**
   - プライマリユーザー設定（`system.primaryUser`、nix-darwin 25.05以降で必須）
   - ユーザー定義（name, home, shell）
   - macOSシステム設定（Dock、Finder、NSGlobalDomain、トラックパッド、スクリーンセーバー等）
   - キーボード設定（CapsLockをControlに変更）
   - スクリーンショット保存設定
   - `system.stateVersion = 5`

3. **`hosts/darwin/configuration.nix`でシステムモジュールを統合**
   - `./default.nix`（macOS固有設定）をインポート
   - `modules/system/zsh-system.nix`をインポート（NixOSと共用可能）
   - Nix実験的機能の有効化、nixpkgs設定
   - **Nixパッケージマネージャーの無効化**（`nix.enable = false`）：Homebrewをメインのパッケージマネージャーとして使用する場合に設定
   - Homebrew有効化（**注意**: nix-darwinインストール前に手動でHomebrewをインストールする必要があります）
   - システム共通パッケージ（zsh, git）
   - 注意: `modules/system/common.nix`はNixOS専用のため、macOSでは使用しない

4. **`hosts/darwin/home.nix`でユーザー環境モジュールを統合**
   - `modules/home/`をインポート（完全にOS非依存なので、そのまま再利用可能）
   - macOS用ユーザー設定（username, homeDirectory, stateVersion）

5. **`flake.nix`に`darwinConfigurations`を追加**
   - `inputs.darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.05"`を追加（リリースブランチを明示）
   - `darwinConfigurations.darwin`を定義
   - `system = "aarch64-darwin"`を指定
   - `pkgs-unstable`をaarch64-darwin用に定義し、specialArgsとextraSpecialArgsで渡す

6. **共通設定の再利用性**
   - `modules/home/`: **ほぼそのまま使用可能**（git, zsh, tmux, neovim, claude）
     - 注意: ghosttyは現在macOSでbrokenのため無効化
     - Linux専用パッケージ（nettools, fping, iputils）はNixOS-WSL環境のhome.nixのみで定義
   - `modules/system/zsh-system.nix`: そのまま使用可能
   - `modules/system/common.nix`: **macOSでは使用不可**（Docker等はNixOS専用）、必要な設定は`hosts/darwin/configuration.nix`に直接記述

### Gitサブモジュールの管理
- **初回クローン時**: `git clone --recursive` または `git submodule update --init --recursive`
- **サブモジュール更新**: `git submodule update --remote` でリモートの最新版を取得
- **neovim/nvim.lua**: Neovim設定をサブモジュールとして管理（https://github.com/amosoisin/nvim.lua）

### パッケージ検索
パッケージ名を調べるには：
- [search.nixos.org](https://search.nixos.org/packages)
- `nix search nixpkgs パッケージ名`

## 主要設定値

| 項目 | NixOS-WSL | macOS (darwin) |
|------|-----------|----------------|
| ユーザー名 | nixos | amosoisin |
| ホームディレクトリ | /home/nixos | /Users/amosoisin |
| シェル | Zsh | Zsh |
| エディタ | Neovim | Neovim |
| タイムゾーン | Asia/Tokyo | （システム設定に依存） |
| ロケール | ja_JP.UTF-8 | （システム設定に依存） |
| パッケージマネージャー | Nix | Homebrew（`nix.enable = false`） |
| State version | 25.05 | 5 |
| システムアーキテクチャ | x86_64-linux | aarch64-darwin |

## コマンドリファレンス

### NixOS管理（エイリアス）
```bash
nrs   # sudo nixos-rebuild switch --flake .#nixos  （設定適用）
nrt   # sudo nixos-rebuild test --flake .#nixos    （テスト）
nrb   # sudo nixos-rebuild boot --flake .#nixos    （次回起動時反映）
nfu   # nix flake update                            （Flakes更新）
nse   # nix search nixpkgs                          （パッケージ検索）
```

### macOS (darwin) 管理
```bash
darwin-rebuild switch --flake .#darwin  # 設定適用
darwin-rebuild build --flake .#darwin   # ビルドのみ（適用しない）
darwin-rebuild check --flake .#darwin   # 設定チェック
nix flake update                         # Flakes更新
nix search nixpkgs                       # パッケージ検索
```

### 開発関連
```bash
lg    # lazygit（Git TUI）
v     # nvim（Neovim起動）
```

# 注意事項
ソースコードの変更を実施した場合は、ドキュメント@CLAUDE.md、@README.mdも変更すること

## トラブルシューティング

### macOS: darwin-rebuild時の`/etc/zshenv`エラー

**症状**:
```
error: Unexpected files in /etc, aborting activation
```

**原因**:
nix-darwinは`/etc`ディレクトリ配下のファイル（`/etc/zshenv`、`/etc/zshrc`など）をシンボリックリンクとして管理します。既存のファイルが存在する場合、安全のため上書きせずにエラーで停止します。

**解決方法**:

1. **既存ファイルの内容を確認**（重要な設定が含まれていないか）:
   ```bash
   cat /etc/zshenv
   ```

2. **バックアップとしてリネーム**:
   ```bash
   sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin
   ```

   他の関連ファイルも必要に応じて同様に処理:
   ```bash
   sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
   sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
   ```

3. **darwin-rebuildを再実行**:
   ```bash
   darwin-rebuild switch --flake .#darwin
   ```

4. **動作確認**:
   - 新しいzshセッションを開く
   - 環境変数やパスが正しく設定されているか確認
   - 問題があれば`modules/home/zsh/default.nix`に設定を追加

**注意事項**:
- バックアップファイル（`.before-nix-darwin`）はnix-darwinアンインストール時に自動復元されません
- 重要な設定が含まれていた場合は、`modules/home/zsh/default.nix`または`hosts/darwin/default.nix`に統合することを推奨

**参考**:
- [nix-darwin Issue #149](https://github.com/LnL7/nix-darwin/issues/149)
- [nix-darwin Issue #912](https://github.com/LnL7/nix-darwin/issues/912)

### yazi: 終了時に「Run preloader 'full-border'」メッセージが表示される

**症状**:
- yaziを終了（`q`キー）する際に、`Run preloader 'full-border'`というメッセージが表示される
- yaziは正常に終了するが、メッセージが毎回表示されて煩わしい
- full-borderプラグインが正しく動作していない可能性がある

**原因**:
full-borderプラグインを`plugin.prepend_preloaders`で設定するのは誤った使用方法です。full-borderプラグインは`init.lua`で`require("full-border"):setup()`を呼び出す必要があります。

**解決方法**:

1. **`modules/home/yazi/default.nix`を編集**:

   **誤った設定（削除する）**:
   ```nix
   settings = {
     # ...
     plugin = {
       prepend_preloaders = [
         { name = "*"; run = "full-border"; }
       ];
     };
   };
   ```

   **正しい設定（追加する）**:
   ```nix
   programs.yazi = {
     # ...
     settings = {
       # mgr, preview等の設定...
     };

     # initLuaオプションを追加（settingsセクションの外側）
     initLua = ''
       require("full-border"):setup()
     '';
   };
   ```

2. **設定を適用**:
   ```bash
   sudo nixos-rebuild switch --flake .#nixos
   # または
   nrs
   ```

3. **動作確認**:
   - yaziを起動し、ウィンドウ全体に角丸のボーダーが表示されることを確認
   - yaziを終了（`q`キー）時にエラーメッセージが表示されないことを確認

**カスタマイズ（オプション）**:
ボーダーのスタイルを変更する場合：
```nix
initLua = ''
  require("full-border"):setup({
    type = ui.Border.PLAIN,  -- シンプルなボーダー
  })
'';
```

**参考**:
- [yazi-rs/plugins: full-border.yazi](https://github.com/yazi-rs/plugins/tree/main/full-border.yazi)
