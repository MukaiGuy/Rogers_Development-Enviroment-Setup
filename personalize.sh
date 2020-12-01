#!/bin/bash

./devsetup.sh && exec cp mukaiguy.zsh-theme ~/.oh-my-zsh/themes/mukaiguy.zsh-theme && sudo rm ~/.zshrc && cp zshrc ~/.zshrc && source ~/.zshrc
