## Setup a new macbook

https://ohmyz.sh/
https://brew.sh/

brew install --cask visual-studio-code
brew install --cask iterm2
brew install --cask github
brew install --cask telegram
brew install --cask slack
brew install --cask docker
brew install --cask adobe-acrobat-reader
brew install --cask appcleaner
brew install --cask deepl
brew install --cask snipaste

brew install pyenv

ZSH_THEME="crcandy"

defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'

killall Dock
