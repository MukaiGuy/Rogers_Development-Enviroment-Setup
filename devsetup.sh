#!/bin/bash

sudo apt-get update && sudo apt full-upgrade -y && sudo apt-get install -y zsh git curl python3-venv python3-pip python3.8 && sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && sudo apt-get install fzf && cp mukaiguy.zsh-theme ~/.oh-my-zsh/themes/mukaiguy.zsh-theme && sudo rm ~/.zshrc && cp zshrc ~/.zshrc && source ~/.zshrc
