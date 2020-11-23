!#/bin/bash 

sudo apt-get update && sudo apt full-upgrade -y

sudo ap-get install -y zsh git curl python3-venv python3-pip python3.8

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

sudo apt install fzf

mv mukaiguy.zsh-theme ~/.oh-my-zsh/themes/

sudo rm ~/.zshrc

mv .zshrc ~/

source ~/.zshrc