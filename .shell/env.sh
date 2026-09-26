# shellcheck shell=bash
# Environment variables shared by bash and zsh.

# Make devbox global packages (nvim, bat, lazygit, yq, ...) available in every
# shell. Guarded so a missing devbox binary is harmless. This spawns a devbox
# process on shell startup (~80ms); if that ever becomes noticeable we can cache
# the output instead.
if command -v devbox >/dev/null 2>&1; then
  eval "$(devbox global shellenv 2>/dev/null)"
fi

export PATH="$HOME/.local/bin:$PATH"
export TERM=xterm-256color

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export GIT_EDITOR="${GIT_EDITOR:-$EDITOR}"
export PAGER="${PAGER:-less}"
export LESS="${LESS:--R}"

# Use bat as the man pager and syntax highlighter (Catppuccin Mocha).
if command -v bat >/dev/null 2>&1; then
  export BAT_THEME="${BAT_THEME:-Catppuccin Mocha}"
  export MANPAGER="bat -p"
  export BAT_PAGER="less -R"
fi

# eza colours (Catppuccin Mocha).
export EZA_COLORS="${EZA_COLORS:-di=38;2;137;180;250:ex=38;2;166;227;161:ln=38;2;137;220;235:or=38;2;243;139;168:pi=38;2;249;226;175:so=38;2;245;194;231:bd=38;2;203;166;247:cd=38;2;203;166;247:*.tar=38;2;250;179;135:*.gz=38;2;250;179;135:*.zip=38;2;250;179;135:*.py=38;2;249;226;175:*.rs=38;2;250;179;135:*.lua=38;2;137;180;250:*.md=38;2;166;227;161:*.json=38;2;249;226;175:*.yml=38;2;245;194;231:*.yaml=38;2;245;194;231}"

# fzf defaults + Catppuccin Mocha colours (respect any value already set).
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:---height 40% --layout=reverse --border --info=inline --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8,selected-bg:#313244}"
