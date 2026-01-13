# Custom aliases

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# List files (using eza - home-managerで統合されているため自動設定)
# ezaのエイリアスはhome.nixのprograms.ezaで設定済み

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias gf='git fetch'
alias gm='git merge'

# lazygit
alias lg='lazygit'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# NixOS
alias nrs='sudo nixos-rebuild switch --flake .'
alias nrt='sudo nixos-rebuild test --flake .'
alias nrb='sudo nixos-rebuild boot --flake .'
alias nfu='nix flake update'
alias nsh='nix-shell'
alias nse='nix search nixpkgs'

# Docker
alias d='docker'
alias dc='docker compose'
alias dps='docker ps'
alias dimg='docker images'
alias dex='docker exec -it'
alias drm='docker rm'
alias drmi='docker rmi'

# tmux
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'

# bat (cat replacement)
alias cat='bat --paging=never'
alias catp='bat'

# fd (find replacement)
alias find='fd'

# ripgrep
alias rg='rg --smart-case'

# neovim
alias v='nvim'
alias vi='nvim'
