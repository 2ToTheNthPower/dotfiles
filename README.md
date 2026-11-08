# dotfiles

Bash/zsh, tmux, Neovim (LazyVim), git, lazygit, btop, and ruff config.
CLI tools come from a [devbox](https://www.jetify.com/devbox) global config.

Tested on Ubuntu 20.04 and newer; written to also run on macOS (zsh,
bash 3.2, BSD tools).

## Install

Prerequisites: git, GNU stow, and [devbox](https://www.jetify.com/devbox).

```sh
sudo apt install git stow       # Ubuntu
brew install stow               # macOS (git comes with Xcode CLT)
curl -fsSL https://get.jetify.com/devbox | bash
```

Then:

```sh
git clone git@github.com:2ToTheNthPower/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh -n   # dry run
./install.sh
```

`install.sh` symlinks everything into `$HOME` with GNU stow and runs
`devbox global install`. Existing real files are moved to `*.pre-dotfiles`.
Re-run it after adding or deleting files in the repo.

### Commit signing

Commits are signed with your SSH key when the machine has one in `~/.ssh` and
its git is 2.34+. `install.sh` decides per machine and writes the result to
`~/.gitconfig.local` (outside the repo). No keys are ever stored here.

- **Ubuntu 20.04** ships git 2.25, which can't SSH-sign and which GUI apps
  use. Upgrade it with `sudo add-apt-repository ppa:git-core/ppa && sudo apt install git`,
  then re-run `install.sh`.
- **macOS** needs the key in the agent: `ssh-add --apple-use-keychain ~/.ssh/id_ed25519`.
- For a "Verified" badge, add the public key as a *signing* key on each forge
  (GitHub, Bitbucket, Gitea).

### Per-machine notes

- The terminal app's own color palette isn't managed here. Pick an Ayu
  palette in it (Ptyxis and GNOME Terminal, iTerm2, Ghostty all have one).
- On macOS, bash login shells read `~/.bash_profile`, not `~/.bashrc`; this
  setup assumes zsh there.

## Layout

| Path | What |
|---|---|
| `.bashrc`, `.zshrc` | Shell-specific setup; both source `.shell/init.sh` |
| `.shell/` | Shared env, aliases, functions, git/python/tmux helpers, proxy toggle, venv auto-activation |
| `.config/nvim/` | LazyVim config |
| `.config/git/` | Global gitignore and opt-in signing settings |
| `.config/bat/` | ayu-dark syntax theme (bat and delta) |
| `.local/share/devbox/global/default/` | Global devbox packages |
| `.local/bin/vscode-init` | Write `.vscode/` settings that format like Neovim |

## Notes

- `devbox global shellenv` output is cached in `~/.cache/devbox-shellenv.sh`
  and refreshed automatically when the devbox lockfile changes.
- Machine-local tweaks that should not be committed can go in `~/.profile`.
