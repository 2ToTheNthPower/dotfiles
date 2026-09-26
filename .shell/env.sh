# shellcheck shell=bash
# Environment variables shared by bash and zsh.

export PATH="$HOME/.local/bin:$PATH"
export TERM=xterm-256color

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export GIT_EDITOR="${GIT_EDITOR:-$EDITOR}"
export PAGER="${PAGER:-less}"
export LESS="${LESS:--R}"

# Use bat for man pages when available.
if command -v bat >/dev/null 2>&1; then
  export MANPAGER="bat -p"
  export BAT_PAGER="less -R"
fi

# fzf defaults (respect any value already set).
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:---height 40% --layout=reverse --border --info=inline}"

# Flags only; use `proxy on` to enable them for the current shell.
[ -s "$HOME/set-proxy.sh" ] && . "$HOME/set-proxy.sh"
