# Custom aliases

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# List files (using eza if available)
if command -v eza &> /dev/null; then
  alias ls='eza'
  alias ll='eza -l'
  alias la='eza -la'
  alias lt='eza --tree'
else
  alias ll='ls -l'
  alias la='ls -la'
fi

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# NixOS
alias nrs='sudo nixos-rebuild switch --flake .'
alias nrt='sudo nixos-rebuild test --flake .'
