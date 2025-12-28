# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Bootstrap Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
fi

# Bootstrap custom Oh My Zsh plugins
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-vi-mode" ]; then
  echo "Installing Zsh Vi Mode plugin."
  git clone https://jeffreytse/zsh-vi-mode.git $ZSH_CUSTOM/plugins/zsh-vi-mode
fi

if [ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ]; then
  echo "Installing Fast Syntax Highlighting plugin."
  git clone https://zdharma-continuum/fast-syntax-highlighting.git $ZSH_CUSTOM/plugins/fast-syntax-highlighting
fi


# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

plugins=(git)

# custom plugins
plugins+=(zsh-vi-mode)
plugins+=(fast-syntax-highlighting)
plugins+=(direnv)

source $ZSH/oh-my-zsh.sh

# User configuration


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

#Starship
eval "$(starship init zsh)"

#gnu tar
export PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

#move-analyzer
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

#add go bins to path
export PATH=$PATH:$(go env GOPATH)/bin
export PATH=$PATH:/usr/local/bin

[[ -s "/Users/henrybaldwin/.gvm/scripts/gvm" ]] && source "/Users/henrybaldwin/.gvm/scripts/gvm"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# ATAC
export ATAC_KEY_BINDINGS="~/.config/atac/vim_key_bindings.toml"
export ATAC_MAIN_DIR="$HOME/.config/atac"

# zoxide
eval "$(zoxide init zsh)"

# avm
export PATH="$HOME/.avm/bin:$PATH"

# Custom aliases and functions

# get the hash of the latest commit
function glch() {
    git log -1 --pretty=format:%H | cat
}

# copy the output of a command to the clipboard and print it
function copy() {
    "$@" | tee >(pbcopy)
}


# reload .zshrc
alias reloadz="exec zsh"

# reset git to most recent local commit
alias ghard="git reset --hard HEAD"
export PATH="$HOME/.fuelup/bin:$PATH"



# bun completions
[ -s "/Users/henrybaldwin/.bun/_bun" ] && source "/Users/henrybaldwin/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
