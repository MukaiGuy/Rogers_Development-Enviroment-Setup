# My Development Environment Setup

## 🚀 Quick & Easy Installation

**New and Improved!** The setup process has been completely automated with enhanced error handling and user feedback.

### One-Command Installation:
```bash
git clone https://github.com/MukaiGuy/Rogers_Development-Enviroment-Setup.git && \
cd Rogers_Development-Enviroment-Setup && \
./Auto_install_improved.sh
```

### Step-by-Step Installation:
1) **Clone this repository:**
   ```bash
   git clone https://github.com/MukaiGuy/Rogers_Development-Enviroment-Setup.git
   ```

2) **Navigate to the directory:**
   ```bash
   cd Rogers_Development-Enviroment-Setup
   ```

3) **Run the auto-installer:**
   ```bash
   ./Auto_install_improved.sh
   ```
   > The script will automatically detect your OS (Linux/macOS) and run the appropriate setup

4) **Restart your terminal or source the new configuration:**
   ```bash
   source ~/.zshrc
   ```

That's it! The installer now handles:
- ✅ OS detection (Linux/macOS)
- ✅ Homebrew installation (macOS)
- ✅ Essential package installation
- ✅ Oh My Zsh setup
- ✅ Custom theme installation
- ✅ Zsh configuration
- ✅ Nano editor configuration
- ✅ fzf installation and setup
- ✅ Automatic backups of existing configurations

## 🔤 Recommended Font: Hack

For the best terminal experience, I highly recommend installing the **Hack** font:

### Download and Install Hack Font:
```bash
# Download Hack font
curl -L -o Hack-v3.003-ttf.zip https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip

# Extract and install (macOS)
unzip Hack-v3.003-ttf.zip
open ttf/*.ttf

# Extract and install (Linux)
unzip Hack-v3.003-ttf.zip -d ~/Downloads/Hack
sudo mkdir -p /usr/share/fonts/truetype/hack
sudo cp ~/Downloads/Hack/ttf/*.ttf /usr/share/fonts/truetype/hack/
sudo fc-cache -fv
```

**Direct Download Link:** [Hack Font v3.003](https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip)

After installation, set **Hack** as your terminal font for optimal readability with the custom theme.

## 📸 Theme Preview

**Enjoy!**

Here is what my customized theme looks like. The theme is automatically installed during setup:

![mukaiguy.zsh-theme](https://github.com/MukaiGuy/Rogers_Development-Enviroment-Setup/blob/master/2020-11-28_My_ZSH-theme.png)

## 🛠️ What Gets Installed

### Automated Installation Includes:
- **Homebrew** (macOS only) - Package manager
- **Essential Tools**: git, curl, wget, pygments, nano
- **Oh My Zsh** - Enhanced zsh framework
- **fzf** - Fuzzy finder with key bindings
- **Custom Theme** - "mukaiguy" theme with custom styling
- **Shell Configuration** - Optimized .zshrc with useful aliases and plugins
- **Nano Configuration** - Syntax highlighting and improved editor settings

### Manual Installation Options:
If you prefer to install components individually, you can run:
- `./osx_setup_improved.sh` - macOS-specific setup only
- `./devsetup.sh` - Linux-specific setup only
- `./personalize.sh` - Additional personalizations

## 💡 System Requirements

### macOS:
- macOS 10.14.6 or higher
- Internet connection for downloading packages

### Linux:
- Ubuntu, Debian, or Raspbian
- `sudo` privileges
- Internet connection for downloading packages

## 🔧 Troubleshooting

### Common Issues:

**Script Permission Denied:**
```bash
chmod +x Auto_install_improved.sh
./Auto_install_improved.sh
```

**Oh My Zsh Already Installed:**
The script detects existing installations and updates rather than reinstalling.

**Homebrew Issues (macOS):**
The script automatically handles Apple Silicon (M1/M2) PATH configuration.

**Backup Files:**
All existing configurations are automatically backed up with timestamps before being replaced.

## 🔄 Alternative Installation Methods

### Python Method (Legacy):
```bash
python install.py
```

### Manual Method:
If the automated installer doesn't work for your setup, you can still follow the manual process detailed in the sections below.

---

## 📚 Reference Information

My preferences for a comfortable development environment and the resources I use the most. If you want to use my experiences to help you learn, that's great! Just keep in mind I don't provide official support - search online for anything you don't understand and use multiple resources to compare notes.

- [Custom Aliases Reference](#-custom-aliases-reference)
- [The Shortcuts](#legacy-shortcuts-reference)
- [The Plugins](#the-plugins)
- [Manual Installation Details](#-manual-installation-details)

### A Note on Operating Systems

- **Linux**: Ubuntu is my primary environment, but it should mostly work on Debian/Raspbian too
- **macOS**: Works on macOS 10.14.6 or higher. [Homebrew](https://brew.sh/) is automatically installed if not present

---

## 🔧 Manual Installation Details

> **Note:** These steps are automatically handled by the improved installer above. This section is for reference or manual installation if needed.

### Terminal Environment


### Update & Install

Note: zsh is not included on Linux but it is included with macOS

```bash
# Q: Why is the second argument apt and not apt-get?
# A: Because full-upgrade is not a command available with apt-get
sudo apt-get update && sudo apt full-upgrade -y

sudo apt-get install -y zsh git curl python3-venv python3-pip python3.10
```

Now you can install oh-my-zsh with this or visit their website for instructions:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Once that's done, install fzf (required for the zsh-interactive-cd plugin):

```bash
# Linux
sudo apt install fzf

# macOS
brew install fzf
```

```bash
# Basic Editing
# Once complete, use nano to edit the zsh configuration
sudo nano ~/.zshrc
# This will open the nano editor. NOTE: to exit nano use control+x and read any prompts at the bottom of the screen.
# From here change your desired settings. For my settings see the ZSH CONFIG Section
```

---

## 🔧 Custom Aliases Reference

The setup includes a comprehensive set of aliases organized by category. Here's the complete list:

### 🛠️ System & Shell Configuration

| Alias | Command | Description |
|-------|---------|-------------|
| `zshconfig` | `sudo nano ~/.zshrc` | Edit zsh configuration file |
| `refresh` | `source ~/.zshrc` | Reload zsh configuration without restarting terminal |
| `themeconfig` | `sudo nano ~/.oh-my-zsh/themes/mukaiguy.zsh-theme` | Edit the custom theme file |
| `cat` | `ccat $1` | Use colorized cat command (requires ccat package) |
| `open` | `xdg-open $1 & echo 'Ta-Da!'` | Open files with default application (Linux) |

### 🔄 System Maintenance & Updates

| Alias | Command | Description |
|-------|---------|-------------|
| `update` | Complex apt update chain | Update system, upgrade packages, remove unnecessary packages, and clean cache |
| `ntpdate` | `sudo ntpdate 129.6.15.29` | Synchronize system time with NTP server |

### 🐍 Python Development

| Alias | Command | Description |
|-------|---------|-------------|
| `python` | `python3` | Use Python 3 by default instead of Python 2 |
| `pip` | `pip3` | Use pip3 by default for package management |
| `updatepip` | Complex pip upgrade command | Update all outdated Python packages at once |

#### Virtual Environment Management

| Alias | Command | Description |
|-------|---------|-------------|
| `newvenv` | `python3 -m venv .venv && cd .venv && source bin/activate && cd ..` | Create new virtual environment and activate it |
| `startvenv` | Function to activate venv | Activate virtual environment in current directory |
| `start` | `cd .venv && source bin/activate && cd ..` | Quick virtual environment activation |
| `exitvenv` | `deactivate` | Deactivate current virtual environment |

#### Django Development

| Alias | Command | Description |
|-------|---------|-------------|
| `django` | `django-admin` | Django administration command shortcut |
| `startdjango` | `django-admin startproject $1 .` | Create Django project in current directory |
| `runserver` | `python manage.py runserver` | Start Django development server |
| `createsuperuser` | `python manage.py createsuperuser` | Create Django superuser account |
| `makeapp` | `python manage.py startapp $1` | Create new Django application |

### 🗃️ Database Management (PostgreSQL)

#### User Management

| Alias | Command | Description |
|-------|---------|-------------|
| `pg_newuser` | `createuser --interactive $1` | Create new PostgreSQL user with interactive prompts |
| `deleteuser` | `dropuser $1 -i` | Delete PostgreSQL user with confirmation |

#### Database Operations

| Alias | Command | Description |
|-------|---------|-------------|
| `newdb` | `createdb $1 -i` | Create new PostgreSQL database with confirmation |
| `deletedb` | `dropdb $1 -i` | Delete PostgreSQL database with confirmation |
| `opendb` | `psql $1` | Connect to specified PostgreSQL database |

### 📁 File System & Navigation

| Alias | Command | Description |
|-------|---------|-------------|
| `newdir` | Function to create and enter directory | Create new directory and immediately navigate into it |
| `devops` | `cd ~/Documents/DevOps/ && ls` | Navigate to development directory and list contents |

### 🔐 Security & Cryptography

| Alias | Command | Description |
|-------|---------|-------------|
| `ssh-keygen` | `ssh-keygen -t ed25519` | Generate SSH key using more secure ed25519 algorithm |
| `newapi` | Function to create API key file | Create/edit API key storage file in ~/.ssh/API_Keys/ |
| `newkey` | `openssl rand -base64 $1` | Generate random base64 key of specified length |

### 📝 Productivity & Note Taking

| Alias | Command | Description |
|-------|---------|-------------|
| `note` | Complex note-taking function | Add timestamped note to QuickNotes.md file |
| `notebook` | `nano ~/Documents/DevOps/QuickNotes.md` | Open notebook file for editing |
| `readnotes` | `xdg-open ~/Documents/DevOps/QuickNotes.md` | Open notebook file for reading |

### 💡 Usage Examples

```bash
# Quick system update
update

# Create and activate Python virtual environment
newvenv

# Start Django project
startdjango myproject
runserver

# Create new database and user
pg_newuser myuser
newdb mydatabase

# Quick note taking
note  # Then type your note

# Create project directory
newdir myproject  # Creates directory and navigates into it

# Generate secure SSH key
ssh-keygen  # Uses ed25519 algorithm automatically
```

## The Shortcuts

## Legacy Shortcuts Reference

> **Note:** The aliases below are the original shortcuts for reference. The complete, organized list is documented above in the [Custom Aliases Reference](#-custom-aliases-reference) section.

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

# Linux upkeep
alias update="f(){ sudo apt-get update -y && sudo apt full-upgrade -y && sudo apt-get autoremove -y && sudo apt autoclean -y && echo 'That was easy! You just updated and cleaned your system'; unset -f f; }; f"

alias refresh="f(){ source ~/.zshrc}; f"

# Easy Directory Setup
alias newdir='f(){ mkdir "$1" && cd "$1"; echo directory "$1" created and you are now inside that new directory; unset -f f; }; f'

# SSH Keygen Default it to ed25519 because its more secure
alias ssh-keygen="ssh-keygen -t ed25519"

# Keep track of your API Keys
alias newapi='f(){ sudo nano ~/Documents/DevOps/API_Keychain/"$1".api; unset -f f; }; f'

# Take notes directly from the command line
# Add A Timestamped Note to Notebook
alias note='echo "\"To Exit the note book press enter then shift+ctrl+c"\" && NOTEBOOK=~/Documents/DevOps/QuickNotes.md ; echo "\n- - -\n`date`\n$USER" >> $NOTEBOOK ; $120 >> $NOTEBOOK '

alias notebook="~/Documents/DevOps/QuickNotes.md"
alias readnotes="xdg-open notebook"
```

## The Plugins

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



