function yazi-launch() {
    local tmp

    tmp=$(mktemp)

    zle -I
    exec </dev/tty >/dev/tty 2>&1
    yazi --cwd-file $tmp
    if [ -f "$tmp" ]; then
        cd $(cat "$tmp")
        rm -f "$tmp"
    fi
}

zle -N yazi-launch
bindkey '^e' yazi-launch
