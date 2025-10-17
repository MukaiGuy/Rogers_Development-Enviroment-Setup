# Unix/Linux Administration Notes

A collection of useful command-line snippets and procedures for Unix/Linux system administration.

---

## Table of Contents

- [Change Default Username on Ubuntu](#change-default-username-on-ubuntu)
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

