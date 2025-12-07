# ~/.zshrc

alias v=nvim
alias ll="ls -al"
alias ..=".."
alias ...="../.."
alias ....="../../.."
alias .....="../../../.."

export PATH="$HOME/.local/bin:$PATH"

export TERM=xterm-256color

eval "$(mise activate zsh)"
eval "$(starship init zsh)"

export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
