#!/usr/bin/env bash

# show full pathes in Finder
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install coreutils
brew install vim
brew install htop
brew install wget

brew cask install iterm2
brew cask install sshfs
brew cask install google-chrome

# Needed by atom if we want to sort python imports
pip install isort

# To generate GPG keys for github (https://help.github.com/articles/generating-a-new-gpg-key/)
brew install gpg

brew install tmux
# https://github.com/tmuxinator/tmuxinator
gem install tmuxinator
pip install beautysh # Beautifier for sh files

#brew install pkg-config
#brew install pandoc

#brew install chrome-cli
#brew cask install google-drive
#brew cask install transmit
#brew cask install spectacle

# Clipboard manager for copy/paste (https://github.com/TermiT/Flycut)
brew cask install flycut
#brew cask install java
#brew cask install paintbrush
#brew cask install the-unarchiver

#brew tap homebrew/versions
#brew install gcc49 --enable-cxx