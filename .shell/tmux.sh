# shellcheck shell=bash
# tmux helpers shared by bash and zsh.

# Attach to (or create) a session named after the current directory.
t() {
  local name
  name="$(basename "$PWD")"
  name="${name//[.:]/_}"
  tmux new-session -A -s "$name" "$@"
}

alias ta='tmux attach'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'
alias tn='tmux new-session -s'
