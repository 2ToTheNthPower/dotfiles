# shellcheck shell=bash
# Git aliases and helpers shared by bash and zsh.

alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate'
alias gco='git checkout'
alias gsw='git switch'
alias gst='git stash'
alias gstp='git stash pop'
alias gb='git branch'
alias gbd='git branch -d'
alias lg='lazygit'

# Rebase the current branch onto the remote's default branch.
grb() {
  local base
  base="$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null)"
  base="${base#origin/}"
  [ -n "$base" ] || base=main
  git fetch origin && git rebase "origin/$base"
}

# Worktrees: gwt <branch> [base-ref] -> create a sibling worktree and cd into it.
gwt() {
  local branch="$1" base="${2:-HEAD}" root name dir
  if [ -z "$branch" ]; then
    echo "usage: gwt <branch> [base-ref]" >&2
    return 1
  fi
  root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "gwt: not inside a git repository" >&2
    return 1
  }
  name="$(basename "$root")"
  dir="$(dirname "$root")/${name}-${branch//\//-}"
  if [ -e "$dir" ]; then
    echo "gwt: $dir already exists" >&2
    return 1
  fi
  git -C "$root" worktree add -b "$branch" "$dir" "$base" && cd "$dir" || return 1
}

gwtl() { git worktree list; }
gwtr() { git worktree remove "${1:-$PWD}"; }
