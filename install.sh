#!/usr/bin/env bash
# Link these dotfiles into $HOME with GNU stow, then install devbox packages.
#
# usage: ./install.sh [-n]
#   -n  dry run: show what stow would change, touch nothing
#
# Safe to re-run. Restowing also removes stale links to files that were
# deleted from the repo. Files listed in .stow-local-ignore are not linked.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dry=()
[ "${1:-}" = "-n" ] && dry=(--simulate)

if ! command -v stow >/dev/null 2>&1; then
  echo "install.sh: GNU stow is required (apt install stow, or devbox global add stow)" >&2
  exit 1
fi

# Real files in $HOME would make stow abort with a conflict. Move them aside.
if [ ${#dry[@]} -eq 0 ]; then
  conflicts=$(stow --dir="$repo" --target="$HOME" --restow --simulate . 2>&1 |
    sed -n 's/.*existing target \(is neither a link nor a directory\|is not owned by stow\): //p;
             s/.*over existing target \(.*\) since neither.*/\1/p') || true
  for f in $conflicts; do
    echo "backing up ~/$f -> ~/$f.pre-dotfiles"
    mv "$HOME/$f" "$HOME/$f.pre-dotfiles"
  done
fi

stow --dir="$repo" --target="$HOME" --restow --verbose=1 "${dry[@]}" .

[ ${#dry[@]} -gt 0 ] && exit 0

# Packages from the (now linked) devbox global config.
if command -v devbox >/dev/null 2>&1; then
  devbox global install
  rm -f "${XDG_CACHE_HOME:-$HOME/.cache}/devbox-shellenv.sh"
else
  echo "devbox not found; install it from https://www.jetify.com/devbox, then run: devbox global install"
fi

# Register the ayu-dark syntax theme with bat (delta reads the same cache).
command -v bat >/dev/null 2>&1 && bat cache --build >/dev/null

# Trusted-signers list for verifying SSH-signed commits locally. Built from the
# public key and git email; kept in ~/.ssh, never in this repo.
pub="$HOME/.ssh/id_ed25519.pub"
signers="$HOME/.ssh/allowed_signers"
if [ -f "$pub" ] && [ ! -f "$signers" ]; then
  email="$(git config --global user.email)"
  printf '%s namespaces="git" %s\n' "$email" "$(cut -d' ' -f1,2 "$pub")" >"$signers"
  chmod 644 "$signers"
  echo "wrote $signers"
elif [ ! -f "$pub" ]; then
  echo "note: no ~/.ssh/id_ed25519.pub; commit signing needs a key (ssh-keygen -t ed25519)"
fi

echo "done. open a new shell to pick everything up."
