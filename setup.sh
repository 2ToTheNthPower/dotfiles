# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install brew (rootless)
git clone https://github.com/Homebrew/brew ~/homebrew

eval "$(~/homebrew/bin/brew shellenv)"
brew update --force --quiet
chmod -R go-w "$(brew --prefix)/share/zsh"

# Install starship
curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin

# Install nice-to-have things (and stow for sim-linking dotfiles)
brew install neovim stow tmux
brew install --cask ghostty
