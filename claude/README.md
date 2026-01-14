# Claude Code設定モジュール

このドキュメントでは、NixOSでClaude Codeを最新バージョンでインストールする仕組みを説明します。

## 概要

Claude Codeは頻繁に更新されるため、安定版のnixpkgs（nixos-25.05）では古いバージョンになりがちです。そこで、nixpkgs-unstableを使用して常に最新バージョンをインストールします。

```
nixpkgs-unstable (最新パッケージ)
        ↓
    flake.nix で取得・定義
        ↓
    pkgs-unstable として home-manager に渡す
        ↓
    claude.nix で claude-code をインストール
```

## 仕組みの解説

### 1. flake.nix - nixpkgs-unstableの定義

```nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";  # ← 追加
  # ... 他のinput ...
};
```

**ポイント:**
- `nixpkgs` = 安定版（システム全体で使用）
- `nixpkgs-unstable` = 最新版（特定パッケージのみ使用）
- 2つのnixpkgsを併用することで、安定性と最新性を両立

### 2. flake.nix - pkgs-unstableの作成と受け渡し

```nix
outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    # ...
    home-manager.extraSpecialArgs = { inherit inputs pkgs-unstable; };
    # ...
  };
```

**ポイント:**
- `import nixpkgs-unstable` = unstableからパッケージセットを作成
- `config.allowUnfree = true` = 非フリーパッケージも許可
- `extraSpecialArgs` = home-managerの各モジュールに`pkgs-unstable`を渡す

### 3. home.nix - pkgs-unstableを受け取る

```nix
{ config, pkgs, lib, inputs, pkgs-unstable, ...}:  # ← pkgs-unstableを追加

{
  imports = [
    # ...
    (import ./claude/claude.nix { inherit pkgs-unstable; })
  ];
}
```

**ポイント:**
- 関数の引数に`pkgs-unstable`を追加して受け取る
- `import`で読み込んだモジュールに`pkgs-unstable`を渡す

### 4. claude.nix - 最新のclaude-codeをインストール

```nix
{ pkgs-unstable, ... }:

{
  home.packages = [
    pkgs-unstable.claude-code  # ← unstableから最新版を取得
  ];
}
```

**ポイント:**
- `pkgs-unstable.claude-code` = unstableから最新のclaude-codeを取得
- 他のパッケージは安定版（`pkgs`）からインストールされる

## なぜこの構成にしたのか

### 問題点
- nixpkgs安定版（nixos-25.05）のclaude-codeは古いバージョン
- Claude Codeは頻繁にアップデートされ、古いバージョンでは動作しないことがある

### 解決策
- nixpkgs-unstableから最新のclaude-codeをインストール
- システム全体は安定版を使用し、特定パッケージのみunstableを使用

### メリット
- 常に最新のClaude Codeを使用可能
- システム全体の安定性は維持
- Nixの再現性・宣言的管理を維持

## よく使うコマンド

### 設定を適用

```bash
# NixOS-WSL環境で実行
sudo nixos-rebuild switch --flake .
# または エイリアス
nrs
```

### Claude Codeを最新に更新

```bash
# nixpkgs-unstableのみ更新
nix flake update nixpkgs-unstable

# 設定を適用
nrs
```

### すべての依存関係を更新

```bash
nix flake update
nrs
```

### インストールされているバージョンを確認

```bash
claude --version
```

## ファイル構成

```
claude/
├── README.md      # このファイル
└── claude.nix     # Claude Codeモジュール設定
```

### claude.nix の役割

| 設定項目 | 説明 |
|---------|------|
| `home.packages` | nixpkgs-unstableからclaude-codeをインストール |

## トラブルシューティング

### Q: Claude Codeが古いバージョンのまま

```bash
# 1. flake.lockを確認（nixpkgs-unstableのrevを確認）
cat flake.lock | grep -A10 nixpkgs-unstable

# 2. 更新して再適用
nix flake update nixpkgs-unstable
nrs
```

### Q: 「この環境は最新ではありません」エラー

Claude Codeの要件を満たすバージョンがnixpkgs-unstableにない可能性があります：

```bash
# 最新のunstableに更新
nix flake update nixpkgs-unstable
nrs
```

それでも解決しない場合は、npmで直接インストールする方法もあります（Nixの管理外になります）：

```bash
npm install -g @anthropic-ai/claude-code
```

### Q: 他のパッケージもunstableにしたい

claude.nixの`home.packages`に追加：

```nix
{ pkgs-unstable, ... }:

{
  home.packages = [
    pkgs-unstable.claude-code
    pkgs-unstable.some-other-package  # ← 追加
  ];
}
```

または、別のモジュール（例：`foo/foo.nix`）で同様に`pkgs-unstable`を受け取って使用できます。

## 安定版とunstableの使い分け

| 用途 | 使用するpkgs | 理由 |
|------|-------------|------|
| システムツール | `pkgs`（安定版） | 安定性重視 |
| 開発言語・ツール | `pkgs`（安定版） | 互換性重視 |
| 頻繁に更新されるCLI | `pkgs-unstable` | 最新機能が必要 |
| Claude Code | `pkgs-unstable` | 古いバージョンでは動作しない |

## 参考リンク

- [Nix Flakes公式ドキュメント](https://nixos.wiki/wiki/Flakes)
- [home-manager マニュアル](https://nix-community.github.io/home-manager/)
- [Claude Code ドキュメント](https://docs.anthropic.com/en/docs/claude-code)
- [nixpkgs-unstable](https://github.com/NixOS/nixpkgs/tree/nixos-unstable)
