# Environment variables and PATH settings
# 注意: 基本的な環境変数はhome.nixのhome.sessionVariablesで管理

# Rust/Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# Rustup初期化（デフォルトツールチェーンとrust-analyzerのセットアップ）
if command -v rustup &> /dev/null; then
  # デフォルトツールチェーンが未設定の場合のみインストール
  if ! rustup default 2>&1 | grep -q stable; then
    echo "Rustup: デフォルトツールチェーンをインストール中..."
    rustup default stable
  fi
  # rust-analyzerがなければインストール
  if ! rustup component list --installed 2>/dev/null | grep -q rust-analyzer; then
    echo "Rustup: rust-analyzerをインストール中..."
    rustup component add rust-analyzer
  fi
fi

# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# lua-language-server (NixOSで管理されているため不要だが互換性のため)
# export PATH="$HOME/lua-language-server/bin:$PATH"