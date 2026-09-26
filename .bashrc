# ~/.bashrc

# If not running interactively, don't do anything.
case $- in
*i*) ;;
*) return ;;
esac

alias v=nvim

# Directory navigation. autocd lets a bare path act like `cd <path>`.
shopt -s autocd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

export PATH="$HOME/.local/bin:$PATH"

export TERM=xterm-256color

[ -s "$HOME/set-proxy.sh" ] && source "$HOME/set-proxy.sh"

# History: bigger, deduped, shared across sessions.
HISTFILE="$HOME/.bash_history"
HISTSIZE=50000
HISTFILESIZE=50000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend cmdhist

# Colorized ls/grep, plus handy ls aliases.
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Completion.
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# fzf: Ctrl-R history search + **<tab> fuzzy completion.
command -v fzf >/dev/null && source <(fzf --bash)
