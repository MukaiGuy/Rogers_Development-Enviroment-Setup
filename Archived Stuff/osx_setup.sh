#!/bin/bash


/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && sleep 5 && brew install git curl wget pygments nano && sleep 10 && sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && sleep 10 && brew install fzf &&  sleep 10 && cp mukaiguy.zsh-theme ~/.oh-my-zsh/themes/mukaiguy.zsh-theme && sleep 10 && sudo rm ~/.zshrc && cp zshrc ~/.zshrc sleep 10 && source ~/.zshrc
