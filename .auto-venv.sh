# Auto-activate a Python virtualenv based on the current directory.
#
# Looks for a "venv" or ".venv" in the current directory or any of its parents
# and sources its activate script. When you leave the project the venv is torn
# down again. Shared by ~/.bashrc and ~/.zshrc.
#
# This hook only auto-deactivates venvs that it activated itself, so a venv you
# activate by hand is left alone until you cd somewhere else.

# Virtualenv directories to look for (in priority order).
_AUTO_VENV_NAMES=(.venv venv)

# The venv this hook activated, if any.
_AUTO_VENV_ACTIVE=""

# Last directory checked, so we don't rescan on every prompt.
_AUTO_VENV_LAST_PWD=""

_auto_venv_find() {
  local dir="$PWD" name
  while :; do
    for name in "${_AUTO_VENV_NAMES[@]}"; do
      if [ -f "$dir/$name/bin/activate" ]; then
        printf '%s\n' "$dir/$name"
        return 0
      fi
    done
    [ "$dir" = "/" ] && break
    dir="${dir%/*}"
    [ -n "$dir" ] || dir="/"
  done
  return 1
}

_auto_venv() {
  # Nothing to do unless the directory changed.
  [ "$PWD" = "$_AUTO_VENV_LAST_PWD" ] && return
  _AUTO_VENV_LAST_PWD="$PWD"

  local venv
  venv=$(_auto_venv_find) || venv=""

  # Already exactly where we want to be?
  [ -n "$venv" ] && [ "$venv" = "${VIRTUAL_ENV:-}" ] && return

  if [ -z "$venv" ]; then
    # Left the project: undo a venv we activated, leave a manual one alone.
    if [ -n "$_AUTO_VENV_ACTIVE" ] && [ "${VIRTUAL_ENV:-}" = "$_AUTO_VENV_ACTIVE" ]; then
      deactivate 2>/dev/null || true
    fi
    _AUTO_VENV_ACTIVE=""
    return
  fi

  # Switching to a different venv: drop whatever is currently active.
  if [ -n "${VIRTUAL_ENV:-}" ]; then
    deactivate 2>/dev/null || true
  fi
  # shellcheck disable=SC1090,SC1091
  . "$venv/bin/activate"
  _AUTO_VENV_ACTIVE="$VIRTUAL_ENV"
}
