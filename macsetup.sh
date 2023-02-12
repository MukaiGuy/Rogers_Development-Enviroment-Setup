#!/bin/bash

sudo brew install python3 zsh git curl python3-venv python3-pip && sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && sudo brew install fzf && cp mukaiguy.zsh-theme ~/.oh-my-zsh/themes/mukaiguy.zsh-theme && sudo rm ~/.zshrc && cp zshrc ~/.zshrc && source ~/.zshrc
