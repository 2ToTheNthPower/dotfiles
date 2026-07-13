# ~/.zshrc

alias v=nvim

# Directory navigation. auto_cd lets a bare path act like `cd <path>`.
setopt auto_cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# `ll` prefers eza (nicer output + git status), falls back to plain ls.
if command -v eza >/dev/null; then
  alias ll="eza -al --git --group-directories-first"
else
  alias ll="ls -al"
fi

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

eval "$(mise activate zsh)"
eval "$(starship init zsh)"

export PATH="$HOME/.local/share/bob/nvim-bin:$HOME/homebrew/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fzf: Ctrl-R history search + **<tab> fuzzy completion.
command -v fzf >/dev/null && source <(fzf --zsh)

# zoxide: `z <dir>` jumps to frecent directories.
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# Wrap `uv init` (and `uv init --package`/`--lib`) to append house ruff defaults
# to the generated pyproject.toml. Every other `uv` command passes straight
# through. Templates live in the dotfiles repo, not cookiecutter, because we only
# append a [tool.ruff] block to uv's output (uv emits none) — no merge needed.
uv() {
  if [[ "$1" != "init" ]]; then
    command uv "$@"
    return
  fi

  local out rc
  out="$(command uv "$@" 2>&1)"; rc=$?
  print -r -- "$out"
  (( rc == 0 )) || return $rc

  # uv prints: Initialized project `name` at `/abs/path` — grab the path
  # (field 4 when splitting on backticks). Skips --script mode ("Initialized
  # script …"), which produces no project line and no pyproject.toml.
  local bt='`' dir
  dir=$(print -r -- "$out" | awk -F"$bt" '/Initialized project/ {print $4; exit}')
  [[ -n "$dir" && -f "$dir/pyproject.toml" ]] || return 0
  grep -q '\[tool\.ruff\]' "$dir/pyproject.toml" && return 0

  local tdir="$HOME/dotfiles/.config/uv/init-templates" tmpl="app.toml"
  if [[ " $* " == *" --package "* || " $* " == *" --lib "* ]]; then
    tmpl="package.toml"
  fi
  cat "$tdir/$tmpl" >> "$dir/pyproject.toml"
  print -r -- "→ appended ruff defaults ($tmpl) to $dir/pyproject.toml"
}

