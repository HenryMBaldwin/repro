# Land in the most recent tmux session on ssh login, or start one
if [[ -o interactive ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]] && command -v tmux &>/dev/null; then
    if tmux ls &>/dev/null; then
        tmux attach
    else
        tmux new-session
    fi
fi
