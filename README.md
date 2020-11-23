# My Development Enviroment Setup
My preferences for a comfortable development environment and also the resources I use the most.
If some wants to use my experiances to help them lear thats great!! Just keep in mind I dont privide support. 
Search online for anything you don't understand and use a few resources to compare notes.

### Note About the OS                                                                                                                                             
For Linux people, Ubuntu is my primary envrioment but it should mostly work on Debian/Rasibian too

For Apple People, If you're on a Mac running macOSX 10.14.6 or higher most of my notes should work. If you haven't already install [Homebrew](https://brew.sh/)
 
## Terminal Enviroment                                                                                                                                                                                                                                                                                                            
### Install:                                                                                                                                                                                                                                                                                                                
 ZSH: Not inluded on linux but it is with OSX
 ```bas
sudo apt-get update && sudo apt full-upgrade -y

sudo ap-get install -y zsh git curl python3-venv python3-pip python3.8

```                                                                                                                                                                                                                                                                                          
## oh-my-zsh setup and assuming your using my custom theme

My zshrc is setup with the following plugins
```
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



```bash
            
# For OSX and Liniux
# First run to install oh-my-zsh or visit their website for instructions 
            
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
            
# For Linux
sudo apt install fzf
   
# from inside of of the repo directory
mv mukaiguy.zsh-theme ~/.oh-my-zsh/themes/

# from outside  
mv ~/Rogers_Development-Enviroment-Setup/mukaiguy.zsh-theme ~/.oh-my-zsh/themes/

# Lets delete the regular .zshrc config file (not to worry I have included .zshrc-orig thats a backup of the standard zshrc)
sudo rm ~/.zshrc 

# Now we can move the customized and activate it .zshrc file 
mv ~/Rogers_Development-Enviroment-Setup/.zshrc ~/ && source ~/.zshrc

    
    
````   
# For OSX
    brew install fzf      
# For OSX and Liniux 
Once complete type the following command to enter the settings/config preferances I use nano of basic tasks and its built in on Linux and OSX
```
# For OSX and Liniux 
# Once complete type the following command to enter the settings/config preferances I use nano of basic tasks and its built in on Linux and OSX
    
    sudo nano ~/.zshrc
            
    # This will open the nano editor, NOTE to exit nano use control+x and read any prompts at the bottom of the screen.
    # From here change your desiered settings and for my setting see the ZSH CONFIG Section

```
           
 #### ZSH CONFIG (.zshrc file): copy & paste from the linked repository.                                                                                           
[.zshrc settings |  https://github.com/MukaiGuy/Rogers_Development-Enviroment-Setup/blob/master/.zshrc-configs ]  

# My CLI shorcuts 
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

# SSH Keygen Default it ed25519
        alias ssh-keygen="ssh-keygen -t ed25519"
       
# SSH and API Keys
        alias newapi='f(){ sudo nano ~/.ssh/API_Keys/"$1".api; unset -f f; }; f'
```

