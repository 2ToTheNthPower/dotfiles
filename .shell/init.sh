# shellcheck shell=bash
# Shared shell initialization for bash and zsh.
# Sourced from ~/.bashrc and ~/.zshrc. Keep shell-specific bits (setopt/shopt,
# PROMPT_COMMAND, readline, compinit) in the rc files; everything portable
# lives here so bash and zsh stay in sync.

SHELL_DIR="$HOME/.shell"

for _module in env aliases functions git python tmux proxy venv; do
  # shellcheck disable=SC1090
  [ -s "$SHELL_DIR/$_module.sh" ] && . "$SHELL_DIR/$_module.sh"
done
unset _module
