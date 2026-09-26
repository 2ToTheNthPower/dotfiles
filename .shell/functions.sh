# shellcheck shell=bash
# Small shell functions shared by bash and zsh.

# mkdir + cd.
mkcd() {
  [ -n "$1" ] || { echo "usage: mkcd <dir>" >&2; return 1; }
  mkdir -p "$1" && cd "$1" || return 1
}
alias take='mkcd'

# cd up N levels (default 1).
up() {
  local n="${1:-1}" path=""
  while [ "$n" -gt 0 ]; do
    path="$path../"
    n=$((n - 1))
  done
  cd "$path" || return
}

# Extract most common archive types.
extract() {
  [ -f "$1" ] || { echo "extract: no such file: $1" >&2; return 1; }
  case "$1" in
  *.tar.bz2 | *.tbz2) tar xjf "$1" ;;
  *.tar.gz | *.tgz) tar xzf "$1" ;;
  *.tar.xz | *.txz) tar xJf "$1" ;;
  *.tar.zst) tar --zstd -xf "$1" ;;
  *.tar) tar xf "$1" ;;
  *.bz2) bunzip2 "$1" ;;
  *.gz) gunzip "$1" ;;
  *.zip) unzip "$1" ;;
  *.7z) 7z x "$1" ;;
  *.rar) unrar x "$1" ;;
  *.zst) unzstd "$1" ;;
  *) echo "extract: unsupported archive: $1" >&2; return 1 ;;
  esac
}

# Serve the current directory over HTTP.
serve() {
  python3 -m http.server "${1:-8000}"
}

# Kill process(es) listening on a TCP port.
killport() {
  local port="$1" pids=""
  [ -n "$port" ] || { echo "usage: killport <port>" >&2; return 1; }
  if command -v lsof >/dev/null 2>&1; then
    pids="$(lsof -ti "tcp:$port" 2>/dev/null)"
  elif command -v fuser >/dev/null 2>&1; then
    pids="$(fuser -n tcp "$port" 2>/dev/null)"
  fi
  if [ -n "$pids" ]; then
    kill $pids
  else
    echo "killport: nothing listening on $port" >&2
    return 1
  fi
}

# List listening sockets.
ports() {
  if command -v ss >/dev/null 2>&1; then
    ss -tulpn
  elif command -v netstat >/dev/null 2>&1; then
    netstat -tulpn
  else
    echo "ports: neither ss nor netstat found" >&2
    return 1
  fi
}

# fzf-powered directory jump.
fcd() {
  command -v fzf >/dev/null 2>&1 || { echo "fcd: fzf not installed" >&2; return 1; }
  local dir
  if command -v fd >/dev/null 2>&1; then
    dir="$(fd --type d --hidden --exclude .git | fzf)" || return
  else
    dir="$(find . -type d -not -path '*/.git/*' | fzf)" || return
  fi
  [ -n "$dir" ] || return
  cd "$dir" || return
}

# fzf-powered process killer.
fkill() {
  command -v fzf >/dev/null 2>&1 || { echo "fkill: fzf not installed" >&2; return 1; }
  local pid
  pid="$(ps -eo pid=,args= | fzf --header 'PID  COMMAND' | awk '{print $1}')" || return
  [ -n "$pid" ] && kill "$pid"
}

# Re-source the current shell's startup file.
reload() {
  if [ -n "${ZSH_VERSION:-}" ]; then
    . "$HOME/.zshrc"
  else
    . "$HOME/.bashrc"
  fi
}

# Jump to the dotfiles repo.
dots() { cd "$HOME/dotfiles" || return; }
