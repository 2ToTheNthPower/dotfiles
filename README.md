# dotfiles

Bash/zsh, tmux, Neovim (LazyVim), git, lazygit, btop, and ruff config.
CLI tools come from a [devbox](https://www.jetify.com/devbox) global config.

## Install

```sh
git clone git@github.com:2ToTheNthPower/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh -n   # dry run
./install.sh
```

`install.sh` symlinks everything into `$HOME` with GNU stow and runs
`devbox global install`. Existing real files are moved to `*.pre-dotfiles`.
Re-run it after adding or deleting files in the repo.

## Layout

| Path | What |
|---|---|
| `.bashrc`, `.zshrc` | Shell-specific setup; both source `.shell/init.sh` |
| `.shell/` | Shared env, aliases, functions, git/python/tmux helpers, proxy toggle, venv auto-activation |
| `.config/nvim/` | LazyVim config |
| `.local/share/devbox/global/default/` | Global devbox packages |
| `.local/bin/vscode-init` | Write `.vscode/` settings that format like Neovim |

## Notes

- `devbox global shellenv` output is cached in `~/.cache/devbox-shellenv.sh`
  and refreshed automatically when the devbox lockfile changes.
- Machine-local tweaks that should not be committed can go in `~/.profile`.
