# tmux自動起動（tmux内でない場合のみ）
if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ -t 1 ]; then
    tmux attach >/dev/null 2>&1 || tmux new -A -s dev
fi
