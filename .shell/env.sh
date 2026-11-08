# shellcheck shell=bash
# Environment variables shared by bash and zsh.

# Make devbox global packages (nvim, bat, lazygit, yq, ...) available in every
# shell. `devbox global shellenv` costs ~130ms, so its output is cached and only
# regenerated when the devbox lockfile changes (e.g. after `devbox global add`).
# Delete ~/.cache/devbox-shellenv.sh to force a refresh.
if command -v devbox >/dev/null 2>&1; then
  _dbx_cache="${XDG_CACHE_HOME:-$HOME/.cache}/devbox-shellenv.sh"
  _dbx_lock="$HOME/.local/share/devbox/global/default/devbox.lock"
  if [ ! -s "$_dbx_cache" ] || [ "$_dbx_lock" -nt "$_dbx_cache" ]; then
    mkdir -p "${_dbx_cache%/*}"
    devbox global shellenv 2>/dev/null >"$_dbx_cache.tmp" && mv "$_dbx_cache.tmp" "$_dbx_cache"
  fi
  # shellcheck disable=SC1090
  [ -s "$_dbx_cache" ] && . "$_dbx_cache"
  unset _dbx_cache _dbx_lock
fi

# Put user bins first, moving them to the front if ~/.profile already added
# them, so they win over devbox packages without appearing twice.
for _dir in "$HOME/.opencode/bin" "$HOME/.local/bin"; do
  [ -d "$_dir" ] || continue
  _p=":$PATH:"
  while case $_p in *":$_dir:"*) true ;; *) false ;; esac do
    _p="${_p%%":$_dir:"*}:${_p#*":$_dir:"}"
  done
  _p="${_p#:}"
  PATH="$_dir:${_p%:}"
done
unset _dir _p
export PATH

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export GIT_EDITOR="${GIT_EDITOR:-$EDITOR}"
export PAGER="${PAGER:-less}"
export LESS="${LESS:--R}"

# The prompt (starship) shows the active venv; skip activate's "(venv)" prefix.
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Theme: ayu dark everywhere (matches Neovim's ayu-dark). These are set
# unconditionally so a theme change reaches shells that inherited old values,
# e.g. from a long-running tmux server.

# bat: man pager and syntax highlighting. The ayu-dark theme lives in
# ~/.config/bat/themes; install.sh runs `bat cache --build` to register it.
if command -v bat >/dev/null 2>&1; then
  export BAT_THEME="ayu-dark"
  export MANPAGER="bat -p"
  export BAT_PAGER="less -R"
fi

# eza colours.
export EZA_COLORS="di=38;2;89;194;255:ex=38;2;170;217;76:ln=38;2;57;186;230:or=38;2;217;87;87:pi=38;2;255;180;84:so=38;2;210;166;255:bd=38;2;255;143;64:cd=38;2;255;143;64:*.tar=38;2;242;150;104:*.gz=38;2;242;150;104:*.zip=38;2;242;150;104:*.py=38;2;255;180;84:*.rs=38;2;255;143;64:*.lua=38;2;89;194;255:*.md=38;2;170;217;76:*.json=38;2;230;182;115:*.yml=38;2;210;166;255:*.yaml=38;2;210;166;255"

# fzf defaults and colours.
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline --color=bg+:#1B3A5B,bg:#0B0E14,fg:#BFBDB6,fg+:#E6E1CF,hl:#E6B450,hl+:#E6B450,header:#59C2FF,info:#636A72,prompt:#FF8F40,pointer:#E6B450,marker:#AAD94C,spinner:#95E6CB,border:#454B55,selected-bg:#122132"
