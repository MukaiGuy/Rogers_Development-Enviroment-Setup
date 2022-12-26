export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm


# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/$USER/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="mukaiguy"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
 DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
 COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
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

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="sudo nano ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
        alias ntpdate="sudo ntpdate 129.6.15.29"
# Python
        alias pip="pip3"
        alias updatepip="pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U "
        alias startdjango="django-admin startproject $1 ."
        alias runserver="python manage.py runserver"
        alias createsuperuser="python manage.py createsuperuser"
        alias makeapp="python manage.py startapp $1"
        alias start=' cd .venv && source bin/activate && cd ..'
        alias python="python3.10"
        alias django="django-admin"
        alias newvenv=' python3.10 -m venv .venv && cd .venv && source bin/activate && cd .. '
        alias startvenv='f(){ cd .venv && source bin/activate; unset -f f; }; f'
  alias exitvenv="deactivate"

# Postgres
        alias pg_newuser='createuser --interactive $1'
        alias newdb='createdb $1 -i'
        alias deletedb='dropdb $1 -i'
        alias deleteuser='dropuser $1 -i'
        alias opendb='psql $1 '

# LINUX upkeep
  alias update="f(){ sudo apt-get update -y && sudo apt full-upgrade -y && sudo apt-get autoremove -y && sudo apt-get autoclean -y & echo 'You have updated and cleaned your system'; unset -f f; }; f"

  alias refresh="f(){ source ~/.zshrc}; f"
  alias zshconfig="sudo nano ~/.zshrc"
  alias themeconfig="sudo nano ~/.oh-my-zsh/themes/mukaigiy.zsh-theme"
  
  

#Easy Directory Setup
    alias newdir='f(){ mkdir "$1" && cd "$1"; echo directory "$1" created and you are now inside that new directory; unset -f f; }; f'
# the next two aliases are for linux only
 #  alias class="xdg-open https://generation.instructure.com/courses/247/modules & "
 # xdg-open will use the defualt application for whatever you pass it. I like using it to pull my most visited websites from the commadline.
 #  alias nickname="xdg-open <https://some.example.com/whatever/whatever> & "
	   alias open=" xdg-open $1 & echo 'Ta-Da!' "
 
# SSH Keygen Default it ed25519
  alias ssh-keygen="ssh-keygen -t ed25519"

# Log new API Keys 
   alias newapi='f(){ sudo nano ~/.ssh/API_Keys/"$1".api; unset -f f; }; f'
   
# Add Note to Notebook
	alias note='echo "\"To Exit the note book press enter then shift+ctrl+c"\" && NOTEBOOK=~/Documents/DevOps/QuickNotes.md ; echo "\n- - -\n`date`\n$USER" >> $NOTEBOOK ; $120 >> $NOTEBOOK '

	alias notebook="~/Documents/DevOps/QuickNotes.md"
	alias readnotes="xdg-open notebook"
 
 # Quick Nav to Default programming DIR
 #alias newsetup=" if mkdir ~/Documents/DevOps "
	alias devops="cd ~/Documents/DevOps/ && ls"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
