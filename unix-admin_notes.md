# Unix/Linux Administration Notes

A collection of useful command-line snippets and procedures for Unix/Linux system administration.

---

## Table of Contents

- [Change Default Username on Ubuntu](#change-default-username-on-ubuntu)
- [User Management on macOS](#user-management-on-macos)
- [User and Group Management](#user-and-group-management)
- [File Permissions and Ownership](#file-permissions-and-ownership)
- [System Monitoring](#system-monitoring)
- [Network Administration](#network-administration)
- [Service Management](#service-management)
- [Disk and Storage Management](#disk-and-storage-management)
- [Additional Resources](#additional-resources)

---

## Change Default Username on Ubuntu

**Purpose:** Safely rename a user account on Ubuntu/Debian-based systems.

**Credit:** [Stack Exchange Answer from Muru & Egial](https://askubuntu.com/questions/34074/how-do-i-change-my-username)

### ⚠️ Important Warnings

- **Backup First:** Always backup important data before changing usernames
- **Active Processes:** Ensure no processes are running under the old username
- **PATH Variables:** Update any hardcoded paths that reference the old username
- **SSH Keys:** May need to update SSH key paths and configurations
- **System Dependencies:** Some applications may reference the old username

### Prerequisites

- Root or sudo access
- Ability to create a temporary admin account
- Access via console, SSH, or recovery mode

### Step-by-Step Procedure

#### Step 1: Create Temporary Admin Account

Create a temporary user with sudo privileges:

```bash
# Create new temporary user
sudo adduser temporary

# Add temporary user to sudo group
sudo adduser temporary sudo

# Verify the user was added to sudo group
groups temporary
```

**Note:** You will be prompted to set a password and optionally provide user details.

#### Step 2: Logout and Login as Temporary User

```bash
# Logout from current session
logout
# or
exit
```

Then login as the temporary user:

**Via Console:**

```bash
username: temporary
password: <enter-the-password>
```

**Via SSH:**

```bash
ssh temporary@<host-ip-or-hostname>
```

#### Step 3: Rename the User Account

Now that you're logged in as the temporary user, rename the target account:

```bash
# Change the username (login name)
# Replace <oldUsername> with the current username
# Replace <newUsername> with the desired new username
sudo usermod -l <newUsername> <oldUsername>

# Example:
# sudo usermod -l john ubuntu
```

#### Step 4: Update Home Directory

Rename the home directory to match the new username:

```bash
# Update home directory location and move existing files
sudo usermod -d /home/<newUsername> -m <newUsername>

# Example:
# sudo usermod -d /home/john -m john
```

**Important:** The `-m` flag moves the contents from the old home directory to the new location.

#### Step 5: Update User Group (Optional but Recommended)

If the user has a personal group with the old username, rename it:

```bash
# Rename the user's primary group
sudo groupmod -n <newUsername> <oldUsername>

# Example:
# sudo groupmod -n john ubuntu
```

#### Step 6: Verify Changes

Before logging out, verify the changes:

```bash
# Check user information
id <newUsername>

# Verify home directory
ls -la /home/<newUsername>

# Check user's groups
groups <newUsername>
```

#### Step 7: Logout and Login with New Username

```bash
# Logout from temporary account
logout
```

Login with the new username:

```bash
username: <newUsername>
password: <your-password>
```

**Via SSH:**

```bash
ssh <newUsername>@<host-ip-or-hostname>
```

#### Step 8: Cleanup - Remove Temporary Account

Once you've confirmed everything works with the new username:

```bash
# Remove the temporary user account
sudo deluser temporary

# Remove the temporary user's home directory
sudo rm -rf /home/temporary
```

### Post-Rename Checklist

After renaming, check and update the following:

- [ ] **SSH Keys:** Update paths in `~/.ssh/` if necessary
- [ ] **Cron Jobs:** Update any cron jobs with hardcoded paths
- [ ] **Environment Variables:** Check `~/.zshrc`, `~/.bashrc`, etc. for hardcoded usernames
- [ ] **Application Configs:** Update configs that reference the old username
- [ ] **PATH Variables:** Use `$USER` or `$HOME` instead of hardcoded usernames
- [ ] **File Ownership:** Verify file ownership is correct: `sudo chown -R <newUsername>:<newUsername> /home/<newUsername>`
- [ ] **System Services:** Check any systemd services that reference the user

### Troubleshooting

**Cannot login after rename:**

- Boot into recovery mode
- Verify username with: `cat /etc/passwd | grep <newUsername>`
- Check home directory exists and has correct permissions

**Permission denied errors:**

```bash
# Fix home directory ownership
sudo chown -R <newUsername>:<newUsername> /home/<newUsername>

# Fix home directory permissions
sudo chmod 755 /home/<newUsername>
```

**User still shows old name in some places:**

- Logout and login again
- Restart any running applications
- Clear cache files

### Best Practices

1. **Use Variables:** In scripts and configs, use `$USER` or `$HOME` instead of hardcoded usernames
2. **Document Changes:** Keep a log of what was changed for future reference
3. **Test First:** If possible, test the procedure on a non-production system
4. **Backup Strategy:** Ensure backups are in place before making changes
5. **Timing:** Perform username changes during maintenance windows when system usage is low

---

## User Management on macOS

macOS uses a different user management system than Linux, relying on Directory Services and the `dscl` (Directory Service Command Line) utility.

### Creating Users via Command Line

#### Method 1: Using dscl (Recommended for Scripts)

```bash
#!/bin/bash

# Configuration
USERNAME="newuser"
FULLNAME="New User"
PASSWORD="secure_password"
USERID="501"  # Must be unique, 501+ for regular users

# Create the user account
sudo dscl . -create /Users/$USERNAME
sudo dscl . -create /Users/$USERNAME UserShell /bin/zsh
sudo dscl . -create /Users/$USERNAME RealName "$FULLNAME"
sudo dscl . -create /Users/$USERNAME UniqueID "$USERID"
sudo dscl . -create /Users/$USERNAME PrimaryGroupID 20  # 20 = staff group
sudo dscl . -create /Users/$USERNAME NFSHomeDirectory /Users/$USERNAME

# Set the password
sudo dscl . -passwd /Users/$USERNAME "$PASSWORD"

# Create home directory
sudo createhomedir -c -u $USERNAME

# Add user to admin group (optional - for admin privileges)
sudo dscl . -append /Groups/admin GroupMembership $USERNAME

echo "User $USERNAME created successfully!"
```

#### Method 2: Interactive User Creation

```bash
# Find next available UID
NEXT_UID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1)
NEXT_UID=$((NEXT_UID + 1))

# Set variables
USERNAME="johndoe"
FULLNAME="John Doe"

# Create user
sudo dscl . -create /Users/$USERNAME
sudo dscl . -create /Users/$USERNAME UserShell /bin/zsh
sudo dscl . -create /Users/$USERNAME RealName "$FULLNAME"
sudo dscl . -create /Users/$USERNAME UniqueID "$NEXT_UID"
sudo dscl . -create /Users/$USERNAME PrimaryGroupID 20
sudo dscl . -create /Users/$USERNAME NFSHomeDirectory /Users/$USERNAME

# Set password interactively
sudo dscl . -passwd /Users/$USERNAME

# Create home directory
sudo createhomedir -c -u $USERNAME
```

#### Method 3: Using sysadminctl (macOS 10.10+)

```bash
# Create standard user
sudo sysadminctl -addUser username -fullName "Full Name" -password "userpassword" -home /Users/username

# Create admin user
sudo sysadminctl -addUser username -fullName "Full Name" -password "userpassword" -admin

# Create user with interactive password prompt
sudo sysadminctl -addUser username -fullName "Full Name" -password - -admin
```

### Managing Users

#### List All Users

```bash
# List all users
dscl . -list /Users

# List users with UID
dscl . -list /Users UniqueID

# List only non-system users (UID >= 501)
dscl . -list /Users UniqueID | awk '$2 >= 501 {print $1}'

# Get detailed user information
dscl . -read /Users/username
```

#### Modify User Properties

```bash
# Change user's full name
sudo dscl . -change /Users/username RealName "Old Name" "New Name"

# Change user's shell
sudo dscl . -change /Users/username UserShell /bin/bash /bin/zsh

# Change user's home directory
sudo dscl . -change /Users/username NFSHomeDirectory /Users/oldname /Users/newname

# Change password
sudo dscl . -passwd /Users/username newpassword
```

#### Delete User

```bash
# Delete user account (keeps home directory)
sudo dscl . -delete /Users/username

# Delete user and home directory
sudo dscl . -delete /Users/username
sudo rm -rf /Users/username

# Using sysadminctl (safer method)
sudo sysadminctl -deleteUser username
```

### Group Management

#### List Groups

```bash
# List all groups
dscl . -list /Groups

# List group members
dscl . -read /Groups/admin GroupMembership

# Check if user is in a group
dscl . -read /Groups/admin GroupMembership | grep username
```

#### Add/Remove Users from Groups

```bash
# Add user to group
sudo dscl . -append /Groups/groupname GroupMembership username

# Remove user from group
sudo dscl . -delete /Groups/groupname GroupMembership username

# Add user to admin group (give sudo access)
sudo dscl . -append /Groups/admin GroupMembership username

# Add user to wheel group (alternative admin access)
sudo dscl . -append /Groups/wheel GroupMembership username
```

### Useful User Management Commands

#### Check User Information

```bash
# Get current user
whoami

# Get user ID
id username

# Check if user exists
dscl . -read /Users/username 2>/dev/null && echo "User exists" || echo "User not found"

# View user's groups
groups username
id -Gn username
```

#### Password Management

```bash
# Force password change on next login
sudo pwpolicy -u username -setpolicy "newPasswordRequired=1"

# Set password expiration (days)
sudo pwpolicy -u username -setpolicy "maxMinutesUntilChangePassword=129600"  # 90 days

# Disable password expiration
sudo pwpolicy -u username -clearaccountpolicies

# View password policy
sudo pwpolicy -u username -getpolicy
```

### Complete User Creation Script

Here's a complete script for creating a new user with all options:

```bash
#!/bin/bash

# User Creation Script for macOS
# Usage: sudo ./create_user.sh username "Full Name" [admin]

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   exit 1
fi

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 username \"Full Name\" [admin]"
    exit 1
fi

USERNAME=$1
FULLNAME=$2
MAKE_ADMIN=${3:-no}

# Find next available UID
NEXT_UID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1)
NEXT_UID=$((NEXT_UID + 1))

echo "Creating user: $USERNAME"
echo "Full name: $FULLNAME"
echo "UID: $NEXT_UID"

# Create the user
dscl . -create /Users/$USERNAME
dscl . -create /Users/$USERNAME UserShell /bin/zsh
dscl . -create /Users/$USERNAME RealName "$FULLNAME"
dscl . -create /Users/$USERNAME UniqueID "$NEXT_UID"
dscl . -create /Users/$USERNAME PrimaryGroupID 20
dscl . -create /Users/$USERNAME NFSHomeDirectory /Users/$USERNAME

# Set password
echo "Enter password for $USERNAME:"
dscl . -passwd /Users/$USERNAME

# Create home directory
createhomedir -c -u $USERNAME

# Add to admin group if requested
if [[ "$MAKE_ADMIN" == "admin" ]]; then
    echo "Adding $USERNAME to admin group..."
    dscl . -append /Groups/admin GroupMembership $USERNAME
fi

echo "User $USERNAME created successfully!"
echo "Home directory: /Users/$USERNAME"
echo "Admin privileges: $([[ "$MAKE_ADMIN" == "admin" ]] && echo "Yes" || echo "No")"
```

### macOS User Types

- **System Users (UID < 500)**: System accounts, not for login
- **Regular Users (UID >= 501)**: Standard user accounts
- **Admin Users**: Regular users who are members of the `admin` group
- **Root User (UID 0)**: Disabled by default on modern macOS

### Important Notes

1. **UID Range**: Use 501+ for regular users (macOS reserves 500 and below)
2. **Primary Group**: 20 = staff (standard for macOS users)
3. **Default Shell**: Use `/bin/zsh` (default since macOS Catalina) or `/bin/bash`
4. **Home Directory**: Always create at `/Users/username`
5. **Admin Access**: Add to `admin` group for sudo privileges

### Troubleshooting

**User can't login:**

```bash
# Check if home directory exists
ls -la /Users/username

# Verify user properties
dscl . -read /Users/username

# Check if user has valid shell
dscl . -read /Users/username UserShell
```

**Permission issues:**

```bash
# Fix home directory ownership
sudo chown -R username:staff /Users/username

# Fix home directory permissions
sudo chmod 755 /Users/username
```

### Switching to the New User

#### Method 1: Switch User in Terminal (su)

```bash
# Switch to another user (requires their password)
su - username

# Switch to another user and run a specific command
su - username -c "whoami"

# Switch to root (if enabled)
su -
```

#### Method 2: Login as User via SSH

```bash
# Enable Remote Login first (if not already enabled)
sudo systemsetup -setremotelogin on

# SSH into localhost as the new user
ssh username@localhost

# SSH from another machine
ssh username@your-mac-ip-address
```

#### Method 3: Fast User Switching (GUI)

1. **Enable Fast User Switching:**
   - System Preferences → Users & Groups → Login Options
   - Check "Show fast user switching menu"

2. **Switch Users:**
   - Click your username in the menu bar
   - Select the user you want to switch to
   - Enter their password

#### Method 4: Login from Login Screen

```bash
# Log out current user to return to login screen
# Method 1: Via command line
sudo launchctl bootout user/$(id -u)

# Method 2: Via Apple menu
# Click  → Log Out [username]

# Then select the new user from the login screen
```

#### Method 5: Using sudo to Execute Commands as Another User

```bash
# Run command as another user (requires your password if you're admin)
sudo -u username whoami

# Run command with user's environment
sudo -i -u username

# Open a shell as another user
sudo -u username -s

# Run command as another user without password prompt (if configured)
sudo -u username bash -c 'echo $USER'
```

#### Method 6: Test New User Login

```bash
# Verify user can authenticate
dscl . -authonly username password

# Test login shell
sudo -u username -i bash -c 'echo "Login successful for $USER"'

# Check user's environment
sudo -u username -i env
```

### Complete Login Test Script

```bash
#!/bin/bash
# Test if a user can login successfully

USERNAME=$1

if [[ -z "$USERNAME" ]]; then
    echo "Usage: $0 username"
    exit 1
fi

echo "Testing login for user: $USERNAME"
echo "=================================="

# Check if user exists
if ! dscl . -read /Users/$USERNAME &>/dev/null; then
    echo "❌ User $USERNAME does not exist"
    exit 1
fi
echo "✅ User exists"

# Check home directory
if [[ -d "/Users/$USERNAME" ]]; then
    echo "✅ Home directory exists: /Users/$USERNAME"
else
    echo "❌ Home directory missing: /Users/$USERNAME"
fi

# Check shell
SHELL=$(dscl . -read /Users/$USERNAME UserShell | awk '{print $2}')
echo "✅ User shell: $SHELL"

# Check UID
UID=$(dscl . -read /Users/$USERNAME UniqueID | awk '{print $2}')
echo "✅ User UID: $UID"

# Check groups
GROUPS=$(id -Gn $USERNAME)
echo "✅ User groups: $GROUPS"

# Check if admin
if dscl . -read /Groups/admin GroupMembership 2>/dev/null | grep -q $USERNAME; then
    echo "✅ User has admin privileges"
else
    echo "ℹ️  User is a standard user (no admin privileges)"
fi

echo ""
echo "To login as this user:"
echo "  1. Via terminal: su - $USERNAME"
echo "  2. Via SSH: ssh $USERNAME@localhost"
echo "  3. Via GUI: Log out and select $USERNAME at login screen"
```

### Quick Reference for User Switching

| Method | Command | Notes |
|--------|---------|-------|
| Switch user in terminal | `su - username` | Requires user's password |
| Run command as user | `sudo -u username command` | Requires your admin password |
| Open shell as user | `sudo -u username -s` | Opens user's default shell |
| SSH as user | `ssh username@localhost` | Remote Login must be enabled |
| Test authentication | `dscl . -authonly username password` | Validates credentials |
| Log out current user | `sudo launchctl bootout user/$(id -u)` | Returns to login screen |

### Tips for Testing New Users

1. **Always test in a new terminal window first:**
   ```bash
   # Open new terminal and try
   su - newuser
   ```

2. **Verify home directory contents:**
   ```bash
   sudo -u newuser ls -la /Users/newuser
   ```

3. **Check if user can write to home directory:**
   ```bash
   sudo -u newuser touch /Users/newuser/test.txt
   sudo -u newuser rm /Users/newuser/test.txt
   ```

4. **Verify environment variables:**
   ```bash
   sudo -u newuser -i bash -c 'echo $HOME'
   sudo -u newuser -i bash -c 'echo $USER'
   sudo -u newuser -i bash -c 'echo $SHELL'
   ```

---

## User and Group Management

### Creating Users

```bash
# Create a new user with home directory
sudo adduser username

# Create user without interactive prompts
sudo useradd -m -s /bin/bash username

# Set password for user
sudo passwd username
```

### Managing Groups

```bash
# Create a new group
sudo groupadd groupname

# Add user to a group
sudo usermod -aG groupname username

# Remove user from a group
sudo gpasswd -d username groupname

# View user's groups
groups username

# View all groups
cat /etc/group
```

### User Information

```bash
# Display user ID and group information
id username

# List all users
cat /etc/passwd

# List currently logged in users
who
w

# Check last login information
lastlog

# View user account details
sudo chage -l username
```

---

## File Permissions and Ownership

### Understanding Permissions

```bash
# Permission notation:
# r = read (4), w = write (2), x = execute (1)
# Format: owner-group-others
# Example: rwxr-xr-- = 754
```

### Changing Permissions

```bash
# Change file permissions (numeric)
chmod 755 file.sh          # rwxr-xr-x
chmod 644 file.txt         # rw-r--r--
chmod 600 private.key      # rw-------

# Change file permissions (symbolic)
chmod u+x file.sh          # Add execute for user
chmod g-w file.txt         # Remove write for group
chmod o= file.txt          # Remove all permissions for others
chmod a+r file.txt         # Add read for all

# Recursive permission change
chmod -R 755 directory/
```

### Changing Ownership

```bash
# Change file owner
sudo chown username file.txt

# Change file owner and group
sudo chown username:groupname file.txt

# Change only group
sudo chgrp groupname file.txt

# Recursive ownership change
sudo chown -R username:groupname directory/
```

### Special Permissions

```bash
# Set SUID (Set User ID)
chmod u+s file              # or chmod 4755 file

# Set SGID (Set Group ID)
chmod g+s directory         # or chmod 2755 directory

# Set Sticky Bit
chmod +t directory          # or chmod 1755 directory
```

---

## System Monitoring

### Process Management

```bash
# View all running processes
ps aux

# Interactive process viewer
top
htop  # More user-friendly (may need to install)

# Find specific process
ps aux | grep processname
pgrep processname

# Kill a process
kill PID
kill -9 PID  # Force kill
killall processname

# View process tree
pstree
```

### Resource Usage

```bash
# Memory usage
free -h
cat /proc/meminfo

# Disk usage
df -h           # Disk space by filesystem
du -sh *        # Size of directories in current location
du -h --max-depth=1 /path/to/directory

# CPU information
lscpu
cat /proc/cpuinfo

# System uptime and load
uptime
```

### Log Files

```bash
# View system logs
sudo journalctl -xe          # Recent logs
sudo journalctl -f           # Follow logs in real-time
sudo journalctl -u servicename  # Logs for specific service

# Traditional log files
sudo tail -f /var/log/syslog
sudo tail -f /var/log/auth.log
sudo less /var/log/kern.log
```

---

## Network Administration

### Network Configuration

```bash
# Display network interfaces
ip addr show
ifconfig  # Legacy command

# Show routing table
ip route show
route -n

# DNS configuration
cat /etc/resolv.conf

# Test network connectivity
ping -c 4 google.com
ping6 -c 4 google.com  # IPv6

# Trace route to destination
traceroute google.com
mtr google.com  # Better alternative
```

### Network Diagnostics

```bash
# Display network connections
ss -tuln               # All listening TCP/UDP ports
netstat -tuln          # Legacy alternative
lsof -i                # List open network connections

# Check if port is open
nc -zv hostname port
telnet hostname port

# DNS lookup
nslookup domain.com
dig domain.com
host domain.com

# Download/upload speed test
curl -o /dev/null http://speedtest.tele2.net/10MB.zip
```

### Firewall Management (UFW)

```bash
# Enable/disable firewall
sudo ufw enable
sudo ufw disable

# Check firewall status
sudo ufw status verbose

# Allow/deny specific port
sudo ufw allow 22/tcp
sudo ufw deny 80/tcp

# Allow from specific IP
sudo ufw allow from 192.168.1.100

# Delete rule
sudo ufw delete allow 80/tcp

# Reset firewall rules
sudo ufw reset
```

---

## Service Management

### systemd Commands

```bash
# Start/stop/restart service
sudo systemctl start servicename
sudo systemctl stop servicename
sudo systemctl restart servicename
sudo systemctl reload servicename

# Enable/disable service at boot
sudo systemctl enable servicename
sudo systemctl disable servicename

# Check service status
sudo systemctl status servicename
systemctl is-active servicename
systemctl is-enabled servicename

# List all services
systemctl list-units --type=service
systemctl list-units --type=service --state=running

# View service logs
sudo journalctl -u servicename -f
```

### Common Services

```bash
# SSH service
sudo systemctl status ssh
sudo systemctl restart ssh

# Web server (Apache)
sudo systemctl status apache2
sudo systemctl restart apache2

# Web server (Nginx)
sudo systemctl status nginx
sudo systemctl restart nginx

# Database (PostgreSQL)
sudo systemctl status postgresql
sudo systemctl restart postgresql

# Database (MySQL/MariaDB)
sudo systemctl status mysql
sudo systemctl restart mysql
```

---

## Disk and Storage Management

### Disk Information

```bash
# List block devices
lsblk
lsblk -f  # With filesystem information

# Partition information
sudo fdisk -l
sudo parted -l

# Disk usage by filesystem
df -h
df -i  # Inode usage
```

### Mounting and Unmounting

```bash
# Mount a filesystem
sudo mount /dev/sdb1 /mnt/mountpoint

# Unmount a filesystem
sudo umount /mnt/mountpoint
sudo umount -l /mnt/mountpoint  # Lazy unmount

# View mounted filesystems
mount | grep "^/dev"
findmnt

# Edit fstab for persistent mounts
sudo nano /etc/fstab
```

### Disk Space Management

```bash
# Find large files
sudo find / -type f -size +100M -exec ls -lh {} \;

# Find largest directories
sudo du -h / | sort -rh | head -20

# Clean package cache (Debian/Ubuntu)
sudo apt clean
sudo apt autoclean
sudo apt autoremove

# Clean journal logs
sudo journalctl --vacuum-time=7d
sudo journalctl --vacuum-size=500M
```

### Filesystem Operations

```bash
# Check filesystem for errors
sudo fsck /dev/sdb1
sudo fsck -y /dev/sdb1  # Auto-repair

# Create ext4 filesystem
sudo mkfs.ext4 /dev/sdb1

# Create swap space
sudo mkswap /dev/sdb2
sudo swapon /dev/sdb2

# View swap usage
swapon --show
free -h
```

---

## Additional Resources

### Official Documentation

- [Ubuntu Documentation](https://help.ubuntu.com/)
- [Debian Administrator's Handbook](https://debian-handbook.info/)
- [Red Hat System Administration Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/)
- [Arch Linux Wiki](https://wiki.archlinux.org/) - Excellent resource for all Linux distributions

### User Management

- [Ubuntu Documentation - UserAccounts](https://help.ubuntu.com/community/RenameUser)
- [Linux User Management Guide](https://www.linux.com/training-tutorials/how-manage-users-groups-linux/)
- [systemd User Services](https://wiki.archlinux.org/title/Systemd/User)

### Networking

- [Linux Network Administrators Guide](https://tldp.org/LDP/nag2/index.html)
- [UFW Documentation](https://help.ubuntu.com/community/UFW)
- [systemd-networkd](https://wiki.archlinux.org/title/Systemd-networkd)

### Security

- [Linux Security Best Practices](https://www.cisecurity.org/benchmark/distribution_independent_linux)
- [SSH Hardening Guide](https://www.ssh.com/academy/ssh/config)
- [SELinux User's and Administrator's Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/)

### Command Line Tools

- [The Linux Command Line (Free Book)](https://linuxcommand.org/tlcl.php)
- [Bash Guide for Beginners](https://tldp.org/LDP/Bash-Beginners-Guide/html/)
- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)

---

## Contributing

Have additional Unix/Linux admin tips? Feel free to contribute to this document by submitting a pull request.

**Note:** Always test commands in a safe environment before using them in production!

