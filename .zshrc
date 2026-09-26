# ~/.zshrc

# Shared dotfiles helpers (env, aliases, functions, tools, venv, proxy).
[ -s "$HOME/.shell/init.sh" ] && source "$HOME/.shell/init.sh"

# zsh options.
setopt auto_cd

# History: bigger, deduped, shared across sessions.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_all_dups hist_reduce_blanks share_history inc_append_history

# Completion.
autoload -Uz compinit && compinit

# fzf: Ctrl-R history search + **<tab> fuzzy completion.
command -v fzf >/dev/null && source <(fzf --zsh)

# zoxide: smarter cd.
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
