# Neovim設定モジュール

このドキュメントでは、NixOSでGitHubからNeovim設定を取得して適用する仕組みを説明します。

## 概要

Neovimの設定ファイル（init.lua, lua/など）をGitHubリポジトリから自動的に取得し、`~/.config/nvim`に配置します。

```
GitHub (amosoisin/nvim.lua)
        ↓
    flake.nix で取得
        ↓
    neovim.nix で配置
        ↓
    ~/.config/nvim に展開
```

## 仕組みの解説

### 1. flake.nix - 外部リポジトリの定義

```nix
inputs = {
  # ... 他のinput ...

  nvim-config = {
    url = "github:amosoisin/nvim.lua";
    flake = false;  # ← 重要！
  };
};
```

**ポイント:**
- `inputs` = Nix Flakeが依存する外部ソース（リポジトリ、パッケージなど）
- `url` = GitHubリポジトリのURL（`github:ユーザー名/リポジトリ名`形式）
- `flake = false` = このリポジトリはFlakeではなく、単なるファイル群として扱う

### 2. flake.nix - inputsをhome-managerに渡す

```nix
home-manager.extraSpecialArgs = { inherit inputs; };
```

**ポイント:**
- `extraSpecialArgs` = home-managerの各モジュールに追加の引数を渡す
- `inherit inputs` = `inputs = inputs;` の省略形（同名の変数を渡す）
- これにより、home.nixやneovim.nixで`inputs`を使用可能になる

### 3. home.nix - inputsを受け取る

```nix
{ config, pkgs, lib, inputs, ...}:  # ← inputsを追加

{
  imports = [
    # ...
    (import ./neovim/neovim.nix { inherit config pkgs lib inputs; })
  ];
}
```

**ポイント:**
- 関数の引数に`inputs`を追加して受け取る
- `import`で読み込んだモジュールに`inputs`を渡す

### 4. neovim.nix - 設定ファイルを配置

```nix
{ config, pkgs, lib, inputs, ... }:

{
  home.file.".config/nvim" = {
    source = inputs.nvim-config;  # ← GitHubから取得した内容
    recursive = true;             # ← ディレクトリ全体を再帰的にコピー
  };

  programs.neovim = {
    # ... Neovimの設定 ...
  };
}
```

**ポイント:**
- `home.file` = ホームディレクトリにファイル/ディレクトリを配置する機能
- `source` = 配置するファイルのソース（ここではGitHubリポジトリ）
- `recursive = true` = ディレクトリの場合、中身すべてを配置

## よく使うコマンド

### 設定を適用

```bash
# NixOS-WSL環境で実行
sudo nixos-rebuild switch --flake .
# または エイリアス
nrs
```

### Neovim設定を最新に更新

GitHubのnvim.luaリポジトリに変更をpushした後：

```bash
# nvim-configのみ更新（他のinputsは変更しない）
nix flake update nvim-config

# 設定を適用
nrs
```

### すべての依存関係を更新

```bash
nix flake update
nrs
```

## ファイル構成

```
neovim/
├── README.md      # このファイル
└── neovim.nix     # Neovimモジュール設定
```

### neovim.nix の役割

| 設定項目 | 説明 |
|---------|------|
| `home.file.".config/nvim"` | GitHubから設定を取得して配置 |
| `programs.neovim.enable` | Neovimを有効化 |
| `programs.neovim.defaultEditor` | デフォルトエディタに設定 |
| `programs.neovim.viAlias` | `vi`コマンドでNeovimを起動 |
| `programs.neovim.vimAlias` | `vim`コマンドでNeovimを起動 |
| `programs.neovim.extraPackages` | LSPサーバーなど追加パッケージ |

## トラブルシューティング

### Q: 設定が反映されない

```bash
# 1. flake.lockを確認（nvim-configのrevが最新か）
cat flake.lock | grep -A5 nvim-config

# 2. 更新して再適用
nix flake update nvim-config
nrs
```

### Q: ~/.config/nvimが既に存在する

NixOSのhome.fileは既存ファイルを上書きしません。手動で削除してから適用：

```bash
rm -rf ~/.config/nvim
nrs
```

### Q: 特定のブランチやタグを使いたい

flake.nixのurlを変更：

```nix
# 特定のブランチ
nvim-config.url = "github:amosoisin/nvim.lua/branch-name";

# 特定のタグ
nvim-config.url = "github:amosoisin/nvim.lua/v1.0.0";

# 特定のコミット
nvim-config.url = "github:amosoisin/nvim.lua/abc1234";
```

### Q: LSPサーバーを追加したい

neovim.nixの`extraPackages`に追加：

```nix
extraPackages = with pkgs; [
  # 既存のLSP...

  # 追加例
  nil                  # Nix言語
  marksman             # Markdown
  yaml-language-server # YAML
];
```

パッケージ名は [search.nixos.org](https://search.nixos.org/packages) で検索できます。

## 参考リンク

- [Nix Flakes公式ドキュメント](https://nixos.wiki/wiki/Flakes)
- [home-manager マニュアル](https://nix-community.github.io/home-manager/)
- [nvim.lua リポジトリ](https://github.com/amosoisin/nvim.lua)
