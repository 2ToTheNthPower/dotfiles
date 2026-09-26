# ~/.zshrc

alias v=nvim

# Directory navigation. auto_cd lets a bare path act like `cd <path>`.
setopt auto_cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

export PATH="$HOME/.local/bin:$PATH"

export TERM=xterm-256color

[ -s "$HOME/set-proxy.sh" ] && source "$HOME/set-proxy.sh"

# History: bigger, deduped, shared across sessions.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_all_dups hist_reduce_blanks share_history inc_append_history

# Completion.
autoload -Uz compinit && compinit

# fzf: Ctrl-R history search + **<tab> fuzzy completion.
command -v fzf >/dev/null && source <(fzf --zsh)

# Auto-activate the project's Python virtualenv on cd and shell startup.
[ -s "$HOME/.auto-venv.sh" ] && source "$HOME/.auto-venv.sh"
autoload -Uz add-zsh-hook
add-zsh-hook chpwd _auto_venv
_auto_venv

