# ~/.zshrc

alias v=nvim
alias ll="ls -al"
alias ..=".."
alias ...="../.."
alias ....="../../.."
alias .....="../../../.."

export PATH="$HOME/.local/bin:$PATH"

. "$HOME/.local/bin/env"

eval "$(starship init zsh)"

