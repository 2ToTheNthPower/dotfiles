# shellcheck shell=bash
# Python / uv helpers shared by bash and zsh.

# Create (uv if available, else the venv module) and activate a virtualenv.
mkvenv() {
  local path="${1:-.venv}"
  if command -v uv >/dev/null 2>&1; then
    uv venv "$path"
  else
    python3 -m venv "$path"
  fi
  # shellcheck disable=SC1090
  . "$path/bin/activate"
}

alias uvv='uv venv'
alias uvs='uv sync'
alias uvr='uv run'
alias uvu='uv pip install'
alias uvup='uv self update'
alias pyr='uv run python'
alias pyt='uv run pytest'
alias ruffr='uv run ruff'
alias mypyr='uv run mypy'
