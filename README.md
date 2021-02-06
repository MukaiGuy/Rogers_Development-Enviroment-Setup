# My Development Environment Setup
## Quick & Easy
To install everything here follow these steps:
1) Clone this repo, __`git clone https://github.com/MukaiGuy/Rogers_Development-Enviroment-Setup.git`__
2) Move into the cloned directory, __`cd Rogers_Development-Enviroment-Setup`__
3) make the setup script exacutable, __`sudo chmod +x devsetup.sh`__
4) Execut that script with, __`./devsetup.sh`__ -> watch for any prompts.
#### Once thats done we need to copy over the settings.  
5) remove the installed zsh-config with, `rm ~/.zshrc` then copy this zsh-config with `cp zshrc ~/.zshrc` <br>
OR	==> in one line use __`rm ~/.zshrc && cp zshrc ~/.zshrc`__
6) Copy the theme file into the themes folder. __`cp mukaiguy.zsh-theme ~/.oh-my-zsh/themes/mukaiguy.zsh-theme`__
7) Last step! Activate the new zsh-configs! __`source ~/.zshrc`__

__Enjoy!__

Here is what My customized Theme Looks like, if you want to use it just change the theme name to "mukaiguy" and make sure you download it into your oh-my-zsh directory for themes. 

![mukaiguy.zsh-theme](https://github.com/MukaiGuy/Rogers_Development-Enviroment-Setup/blob/master/2020-11-28_My_ZSH-theme.png)

My preferences for a comfortable development environment and also the resources I use the most.
If some want to use my experiences to help them learn that's great!! Just keep in mind I don't provide support. 
Search online for anything you don't understand and use a few resources to compare notes.

* [The Shortcuts](#the-shortcuts)
* [The Plugins](#the-plugins)

#### A note on the OS                                                                                                                                             
For Linux people, Ubuntu is my primary environment but it should mostly work on Debian/Rasibian too. For Apple People, If you're on a Mac running macOSX 10.14.6 
or higher most of my notes should work. If you haven't already install [Homebrew](https://brew.sh/) 



## Terminal Environment                                                                                                                                                                                                                                                                                                            


### Update & Install 
Note: zsh is not included on linux but it is with OSX

 ```bash
# Q: Why is the second argument apt and not apt-get? 
# A: Because full-upgrade is not a command available with the apt-get 
sudo apt-get update && sudo apt full-upgrade -y

sudo apt-get install -y zsh git curl python3-venv python3-pip python3.8
```
Now you can install oh-my-zsh with this or visit their website for instructions 
```bash            
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
```

Once that's done, we need to instal fzf its required for the zsh-interactive-cd plugin:
```
sudo apt install fzf
or
brew install fzf
```

```  
# Basic Editing
Once complete type the following command to enter the settings/config preferences I use nano of basic tasks and its built in on Linux and OSX
sudo nano ~/.zshrc
    # This will open the nano editor, NOTE to exit nano use control+x and read any prompts at the bottom of the screen.
    # From here change your desired settings and for my setting see the ZSH CONFIG Section

```
           

# [The Shortcuts]
```shell
# Python
	alias pip="pip3"
	alias python="python3"
	alias django="django-admin"
	alias newproject='./newproject.sh'
	alias start='f(){ cd .venv && source bin/activate; unset -f f; }; f'

# Postgres
	alias pg_newuser='createuser --interactive $1'
	alias newdb='createdb $1 -i'
	alias deletedb='dropdb $1 -i'
	alias deleteuser='dropuser $1 -i'
	alias opendb='psql $1 '

#LINUX upkeep  
    alias update="f(){ sudo apt-get update -y && sudo apt full-upgrade -y && sudo apt-get autoremove -y && sudo apt autoclean -y && echo 'That was easy! You just updated and cleaned your system'; unset -f f; }; f"

    alias refresh="f(){ source ~/.zshrc}; f"    

# Easy Directory Setup
    alias newdir='f(){ mkdir "$1" && cd "$1"; echo directory "$1" created and you are now inside that new directory; unset -f f; }; f'

# SSH Keygen Default it to ed25519 because its more secure
        alias ssh-keygen="ssh-keygen -t ed25519"
       
# SSH and API Keys
        alias newapi='f(){ sudo nano ~/.ssh/API_Keys/"$1".api; unset -f f; }; f'
```
# [The Plugins]
These are all the plugins I use:
```zsh
plugins=(
pip
python
colorize
git
docker
ubuntu
zsh-interactive-cd
zsh-navigation-tools
)
```



