#!/usr/bin/env bash
# Link these dotfiles into $HOME with GNU stow, then install devbox packages.
# Works on Linux (Ubuntu 20.04+) and macOS. Written for bash 3.2 (macOS
# /bin/bash) and BSD userland, so avoid bash 4+ features and GNU-only flags.
#
# usage: ./install.sh [-n]
#   -n  dry run: show what stow would change, touch nothing
#
# Safe to re-run. Restowing also removes stale links to files that were
# deleted from the repo. Files listed in .stow-local-ignore are not linked.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dry=""
[ "${1:-}" = "-n" ] && dry="--simulate"

if ! command -v stow >/dev/null 2>&1; then
  echo "install.sh: GNU stow is required first:" >&2
  echo "  Ubuntu: sudo apt install stow    macOS: brew install stow" >&2
  exit 1
fi

# Pre-create shared parent dirs. Otherwise, on a fresh $HOME, stow would link
# all of ~/.config or ~/.local into the repo, and every app's own config and
# data would end up inside the dotfiles.
[ -z "$dry" ] && mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share/devbox/global/default"

# Real files in $HOME would make stow abort with a conflict. Move them aside.
# Handles the message formats of both stow 2.3 (Ubuntu 20.04) and 2.4+.
if [ -z "$dry" ]; then
  conflicts=$(stow --dir="$repo" --target="$HOME" --restow --simulate . 2>&1 |
    sed -n -E 's/.*existing target (is neither a link nor a directory|is not owned by stow): //p
               s/.*over existing target (.*) since neither.*/\1/p' | sort -u) || true
  for f in $conflicts; do
    # Skip anything already moved or that is a symlink (stow handles those).
    [ -e "$HOME/$f" ] && [ ! -L "$HOME/$f" ] || continue
    echo "backing up ~/$f -> ~/$f.pre-dotfiles"
    mv "$HOME/$f" "$HOME/$f.pre-dotfiles"
  done
fi

# shellcheck disable=SC2086  # $dry is intentionally empty or one flag
stow --dir="$repo" --target="$HOME" --restow --verbose=1 $dry .

[ -n "$dry" ] && exit 0

# Packages from the (now linked) devbox global config.
if command -v devbox >/dev/null 2>&1; then
  devbox global install
  rm -f "${XDG_CACHE_HOME:-$HOME/.cache}/devbox-shellenv.sh"
else
  echo "devbox not found; install it from https://www.jetify.com/devbox, then run: devbox global install"
fi

# Register the ayu-dark syntax theme with bat (delta reads the same cache).
if command -v bat >/dev/null 2>&1; then
  bat cache --build >/dev/null
fi

# --- per-machine git commit signing ------------------------------------------
# Signing settings live in ~/.config/git/signing.gitconfig (tracked). This
# machine opts in through ~/.gitconfig.local (untracked, outside the repo),
# which names this machine's public key. Nothing secret is ever written here.
setup_signing() {
  local local_cfg="$HOME/.gitconfig.local" marker="# managed by dotfiles/install.sh"
  local pub="" k email v major minor sysgit

  for k in id_ed25519 id_ecdsa id_rsa; do
    if [ -f "$HOME/.ssh/$k.pub" ]; then
      pub="$HOME/.ssh/$k.pub"
      break
    fi
  done
  if [ -z "$pub" ]; then
    echo "signing: no SSH public key in ~/.ssh; commits stay unsigned (create one with ssh-keygen -t ed25519)"
    return 0
  fi

  # SSH signing needs git 2.34+. On Ubuntu 20.04 /usr/bin/git is 2.25, and GUI
  # apps (VS Code etc.) use it rather than devbox's git, so check it too.
  for sysgit in "$(command -v git)" /usr/bin/git; do
    [ -x "$sysgit" ] || continue
    v=$("$sysgit" --version | awk '{print $3}')
    major=${v%%.*}
    minor=${v#*.}
    minor=${minor%%.*}
    if [ "$major" -lt 2 ] || { [ "$major" -eq 2 ] && [ "$minor" -lt 34 ]; }; then
      if [ "${FORCE_SIGNING:-0}" != 1 ]; then
        echo "signing: $sysgit is $v (< 2.34, no SSH signing); commits stay unsigned."
        echo "         Upgrade it (Ubuntu: sudo add-apt-repository ppa:git-core/ppa && sudo apt install git),"
        echo "         or re-run with FORCE_SIGNING=1 if only devbox's git is ever used."
        return 0
      fi
    fi
  done

  if [ -f "$local_cfg" ] && ! grep -qF "$marker" "$local_cfg"; then
    echo "signing: $local_cfg exists and is hand-edited; leaving it alone"
  else
    printf '%s\n[include]\n\tpath = ~/.config/git/signing.gitconfig\n[user]\n\tsigningKey = %s\n' \
      "$marker" "$pub" >"$local_cfg"
    echo "signing: enabled with $pub"
  fi

  # Trusted signers, for verifying signatures locally (git log --show-signature).
  email="$(git config --global user.email || true)"
  if [ -n "$email" ]; then
    printf '%s namespaces="git" %s\n' "$email" "$(cut -d' ' -f1,2 "$pub")" >"$HOME/.ssh/allowed_signers"
  fi
}
setup_signing

echo "done. open a new shell to pick everything up."
