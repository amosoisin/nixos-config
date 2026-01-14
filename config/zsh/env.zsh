# Environment variables and PATH settings
# 注意: 基本的な環境変数はhome.nixのhome.sessionVariablesで管理

# Rust/Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# lua-language-server (NixOSで管理されているため不要だが互換性のため)
# export PATH="$HOME/lua-language-server/bin:$PATH"
