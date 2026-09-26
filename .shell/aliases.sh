# shellcheck shell=bash
# Shell aliases shared by bash and zsh.

# --- editing / navigation -------------------------------------------------
alias v='nvim'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# --- ls / cat replacements ------------------------------------------------
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias l='eza --group-directories-first'
  alias ll='eza -l --group-directories-first'
  alias la='eza -la --group-directories-first'
  alias lt='eza --tree --level=2'
else
  if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
  fi
  alias l='ls -CF'
  alias ll='ls -alF'
  alias la='ls -A'
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
fi

command -v dust >/dev/null 2>&1 && alias du='dust'
command -v btop >/dev/null 2>&1 && alias top='btop'

# --- grep -----------------------------------------------------------------
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
