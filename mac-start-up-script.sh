#!/usr/bin/env bash
echo "BEGIN - Start up script for MAC"

# Resource for config updates
# ~/.macos — https://mths.be/macos

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# command for finding username on MAC
#_USERNAME="id -un"

echo "Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "/Users/$(id -un)/.zprofile"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew update

# For changing echo message colours
RED='\033[0;31m'
GREEN='\033[0;32m'
NEXT='\033[0;33m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${GREEN}BREW - Installing Nodejs${NC}"
brew install node

echo -e "${GREEN}BREW - Installing Brave Browser${NC}"
brew install --cask brave-browser

echo -e "${GREEN}BREW - Installing Firefox${NC}"
brew install --cask firefox

echo -e "${GREEN}BREW - Installing Chrome${NC}"
brew install --cask google-chrome

echo -e "${GREEN}BREW - Installing Edge${NC}"
brew install --cask microsoft-edge

echo -e "${GREEN}BREW - Installing Notion${NC}"
brew install --cask notion

echo -e "${GREEN}BREW - Installing Affinity Designer${NC}"
brew install --cask affinity-designer

echo -e "${GREEN}BREW - Installing Spotify${NC}"
brew install --cask spotify

# https://obsproject.com/
echo -e "${GREEN}BREW - Installing OBS${NC}"
brew install --cask obs

echo -e "${GREEN}BREW - Installing Visual Studio Code${NC}"
brew install --cask visual-studio-code

echo -e "${GREEN}BREW - Installing Sublime Text${NC}"
brew install --cask sublime-text
# add sublime text to path - https://www.sublimetext.com/docs/command_line.html#mac 
# not required based on the homebrew install version
# echo 'export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"' >> ~/.bash_profile

echo -e "${NEXT}VIM - Installing Pathogen${NC}"
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
# create a super simple vimrc file
echo 'execute pathogen#infect()
syntax on
set number
set wrap
filetype plugin indent on' >> "$HOME/.vimrc" 

# Might not end up using VIM so commenting out for now
<< VIM-COMMENT
# Collection of plugins below from: https://www.dunebook.com/best-vim-plugins/ 

echo -e "${NEXT}VIM - Installing sensible.vim, prettier, syntastic, airline and solarized theme${NC}"
cd ~/.vim/bundle && \
git clone https://github.com/tpope/vim-sensible.git
git clone https://github.com/prettier/vim-prettier
git clone https://github.com/preservim/nerdtree.git ~/.vim/bundle/nerdtree
git clone --depth=1 https://github.com/vim-syntastic/syntastic.git
echo 'set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0' >> "$HOME/.vimrc" 
git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes
echo "let g:airline_theme='simple'" >> "$HOME/.vimrc"
# Currently issue with not finding solarized once complete - need to investigate
#git clone git://github.com/altercation/vim-colors-solarized.git
#mv vim-colors-solarized ~/.vim/bundle/
#echo 'set background=dark
#colorscheme solarized' >> "$HOME/.vimrc"

echo -e "${NEXT}VIM - Install YouCompleteMe"
brew install cmake python go
cd ~/.vim/bundle/YouCompleteMe
./install.py --clangd-completer --ts-completer 

echo -e "${NEXT}VIM - Install ctrlp"
mkdir -p ~/.vim/pack/plugins/start
git clone --depth=1 https://github.com/ctrlpvim/ctrlp.vim.git ~/.vim/pack/plugins/start/ctrlp

VIM-COMMENT

echo -e "${PURPLE}MAC - Set default browser to Chrome${NC}"
open -a "Google Chrome" --args --make-default-browser

# Read this - updating preferences on MAC
# https://www.shell-tips.com/mac/defaults/#gsc.tab=0

echo -e "${PURPLE}MAC - Defaults updates${NC}"
# Trackpad: enable tap to click for this user and for the login screen (not sure this works on Monterey)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: map bottom right corner to right-click
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use the Dock to launch apps.
defaults write com.apple.dock persistent-apps -array

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Top left and right screen corner
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tr-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0

# Use a modified version of the Solarized Dark theme by default in Terminal.app
osascript <<EOD
tell application "Terminal"
	local allOpenedWindows
	local initialOpenedWindows
	local windowID
	set themeName to "Solarized Dark xterm-256color"
	(* Store the IDs of all the open terminal windows. *)
	set initialOpenedWindows to id of every window
	(* Open the custom theme so that it gets added to the list
	   of available terminal themes (note: this will open two
	   additional terminal windows). *)
	do shell script "open '$HOME/init/" & themeName & ".terminal'"
	(* Wait a little bit to ensure that the custom theme is added. *)
	delay 1
	(* Set the custom theme as the default terminal theme. *)
	set default settings to settings set themeName
	(* Get the IDs of all the currently opened terminal windows. *)
	set allOpenedWindows to id of every window
	repeat with windowID in allOpenedWindows
		(* Close the additional windows that were opened in order
		   to add the custom theme to the list of terminal themes. *)
		if initialOpenedWindows does not contain windowID then
			close (every window whose id is windowID)
		(* Change the theme for the initial opened terminal windows
		   to remove the need to close them in order for the custom
		   theme to be applied. *)
		else
			set current settings of tabs of (every window whose id is windowID) to settings set themeName
		end if
	end repeat
end tell
EOD

# for app in "Activity Monitor" \
# 	"Address Book" \
# 	"Calendar" \
# 	"cfprefsd" \
# 	"Contacts" \
# 	"Dock" \
# 	"Finder" \
# 	"Google Chrome Canary" \
# 	"Google Chrome" \
# 	"Mail" \
# 	"Messages" \
# 	"Opera" \
# 	"Photos" \
# 	"Safari" \
# 	"SizeUp" \
# 	"Spectacle" \
# 	"SystemUIServer" \
# 	"Terminal" \
# 	"Transmission" \
# 	"Tweetbot" \
# 	"Twitter" \
# 	"iCal"; do
# 	killall "${app}" &> /dev/null
# done
echo "Done. Note that some of these changes require a logout/restart to take effect."


# Enable the below once we are able to update the MAC settings above
echo -e "${PURPLE}MAC - Reboot in 60 seconds to enact all changes${NC}"
sudo shutdown -r +1

# for i in {60..01}
# do
# echo -n "."
# sleep 1
# done
# echo

