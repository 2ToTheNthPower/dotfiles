# shellcheck shell=bash
# ~/.bashrc

# If not running interactively, don't do anything.
case $- in
*i*) ;;
*) return ;;
esac

# Shared dotfiles helpers (env, aliases, functions, tools, venv, proxy).
[ -s "$HOME/.shell/init.sh" ] && . "$HOME/.shell/init.sh"

# Bash-specific options.
shopt -s autocd cdspell globstar checkwinsize 2>/dev/null

# History: bigger, deduped, shared across sessions.
HISTFILE="$HOME/.bash_history"
HISTSIZE=50000
HISTFILESIZE=50000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend cmdhist
# Flush new history lines so other sessions can see them.
if [ -z "${_BASHRC_HISTORY_HOOKED:-}" ]; then
  PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
  _BASHRC_HISTORY_HOOKED=1
fi

# Readline: prefix search on Up/Down, case-insensitive completion.
bind '"\e[A": history-search-backward' 2>/dev/null
bind '"\e[B": history-search-forward' 2>/dev/null
bind 'set completion-ignore-case on' 2>/dev/null
bind 'set show-all-if-ambiguous on' 2>/dev/null

# Completion.
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# fzf: Ctrl-R history search + **<tab> fuzzy completion.
# shellcheck disable=SC1090
command -v fzf >/dev/null && source <(fzf --bash)

# zoxide: smarter cd.
# shellcheck disable=SC1090
command -v zoxide >/dev/null && eval "$(zoxide init bash)"

# opencode
export PATH=/home/aaron/.opencode/bin:$PATH
