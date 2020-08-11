# Commandline Sinpits

## Change the defult username on Ubuntu 
[ Credit Stack Exchange Awnser from Muru & Egial | https://askubuntu.com/questions/34074/how-do-i-change-my-username ]

```bash
# Step 1)  
    sudo adduser temporary

# Step 2) Add User to group
    sudo adduser temporary sudo
    # it will prompt you for a password
    sudo logout
   
# Step 3) Login as the temporary user, 
     sudo login
    $ username: temporary
    $ password:< enter the password>
    
  # If using SSH
    ssh temporary@<host-ip>  
  
# Step 4) As the Tenoirary User
    sudo usermod -l <newUsername> <oldUsername>
    sudo usermod -d /home/newHomeDir -m <newUsername>
    sudo logout
   
# Step 5) 
    sudo login   
  $ username: <newUsername>
  $ password:<youPassword>
  
    sudo deluser temporary
    sudo rm -r /home/temporary
```  

