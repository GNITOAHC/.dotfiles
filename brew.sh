
# Make sure we're using the latest homebrew. 
brew updates

# Upgrade any already-installed formulae. 
brew upgrade

# install some tools
brew install neovim 
brew install node
brew install bat
brew install tree
brew install fzf
brew install tmux

# install cask
brew install --cask iterm2
brew install --cask alt-tab
brew install --cask manila
brew install --cask appcleaner
brew install --cask raycast
brew install --cask hiddenbar


# Remove outdated versions from the cellar.
brew cleanup
