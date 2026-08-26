# ENV

# Source alias files
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.zplug/bin:$HOME/google-cloud-sdk/bin:$PATH:$HOME/.seismic/bin"

# gh cli
export GH_EDITOR="nvim"

# BINDINGS

# Arrow keys in insert mode
bindkey -M viins "$terminfo[kcuu1]" history-beginning-search-backward
bindkey -M viins "$terminfo[kcud1]" history-beginning-search-forward

# j/k in normal mode
bindkey -M vicmd 'k' history-beginning-search-backward
bindkey -M vicmd 'j' history-beginning-search-forward

# FUNCTIONS

# output the current git branch name
function gbc() {
    git branch --show-current
}

# get the hash of the latest commit
function glch() {
    git log -1 --pretty=format:%H | cat
}

# copy the output of a command to the clipboard and print it
function copy() {
    "$@" | tee >(pbcopy)
}

# send stdin to the local host clipboard via OSC 52 (works over ssh + tmux)
function clip() {
    local b64; b64=$(base64 -w0)
    if [ -n "$TMUX" ]; then
        printf '\033Ptmux;\033\033]52;c;%s\007\033\\' "$b64"
    else
        printf '\033]52;c;%s\007' "$b64"
    fi
}

# zsh-vi-mode config (called automatically by zsh-vi-mode)
function zvm_config() {
    ZVM_SYSTEM_CLIPBOARD_ENABLED=true
}
