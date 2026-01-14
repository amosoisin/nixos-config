# 概要

この環境はNixOSやnixが使用可能な環境ではありません。
しかし、外部のNixOS-WSL環境用にNixOSの設定を行います。

## プロジェクト構成

```
nixos-config/
├── flake.nix             # Flakesメイン設定（入力・出力定義）
├── flake.lock            # 依存関係ロックファイル
├── configuration.nix     # NixOSシステムレベル設定
├── home.nix              # home-manager（ユーザー環境）設定
├── .gitignore            # Git除外設定
├── git/                  # Git関連設定
│   └── git.nix           # Gitモジュール設定（エイリアス、グローバルignore等）
├── zsh/                  # Zsh関連設定
│   ├── zsh.nix           # Zshモジュール設定（プラグイン等）
│   └── p10k.zsh          # Powerlevel10kプロンプト設定
├── tmux/                 # tmux関連設定
│   └── tmux.nix          # tmuxモジュール設定（プラグイン等）
└── neovim/               # Neovim関連設定
    ├── README.md         # Neovim設定の仕組み解説（初心者向け）
    └── neovim.nix        # Neovimモジュール設定（LSP、エイリアス等）
```

## ファイルの役割

### flake.nix
- **入力**: nixpkgs, home-manager, nixos-wsl（すべてrelease-25.05）、nvim-config（GitHub）
- **出力**: `nixosConfigurations.nixos`（x86_64-linux）
- モジュール構成を定義

### configuration.nix
- システムレベルの設定（タイムゾーン、ロケール、Docker等）
- WSL固有の設定（Windows相互運用性）
- ユーザー定義（nixosユーザー、グループ設定）
- Nix実験的機能の有効化（flakes, nix-command）

### home.nix
- ユーザー環境のパッケージ管理
- プログラム設定（fzf, zoxide, bat, eza）
- 環境変数（LANG）

### git/
- `git.nix`: Gitモジュール設定（エイリアス、エディタ、グローバルignore等）
- ユーザー固有の設定（name, email）は`~/.gitconfig-user`でincludeされる
- `~/.gitconfig-user`は初回ログイン時に対話的に自動生成される

### zsh/
- `zsh.nix`: Zshモジュール設定（プラグイン管理、Gitユーザー設定自動生成、tmux自動起動）
- `p10k.zsh`: Powerlevel10kプロンプト設定

### tmux/
- `tmux.nix`: tmuxモジュール設定（プラグイン、キーバインド等）

### neovim/
- `neovim.nix`: Neovimモジュール設定（LSPサーバー、エイリアス、Python3サポート等）
- Neovim設定ファイルはGitHub（amosoisin/nvim.lua）から取得し、`~/.config/nvim`に配置

## 編集時の注意事項

### Nix構文
- 属性セットは`{ key = value; }`形式（セミコロン必須）
- リストは`[ item1 item2 ]`形式
- 文字列は`"string"`または`''multi-line''`
- パス参照は`./relative/path`

### 設定変更時の確認事項
1. **flake.nix**: 入力の追加・変更時は`nix flake update`が必要
2. **configuration.nix**: システム設定変更後は`sudo nixos-rebuild switch`
3. **home.nix**: パッケージ追加時は`pkgs.パッケージ名`形式を使用
4. **git/**: Git設定変更後は`sudo nixos-rebuild switch`で反映
5. **zsh/**: Zsh設定変更後は`sudo nixos-rebuild switch`で反映
6. **tmux/**: tmux設定変更後は`sudo nixos-rebuild switch`で反映
7. **neovim/**: Neovim設定変更後は`sudo nixos-rebuild switch`で反映

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
