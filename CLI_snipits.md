# Commandline Sinpits

## Change the defult username on Ubuntu 
[ Credit Stack Exchange Awnser from Muru & Egial | https://askubuntu.com/questions/34074/how-do-i-change-my-username ]

```bash
# Step 1)  
    sudo adduser temporary

# Step 2) Add User to group
    sudo adduser temporary sudo
    sudologout
   
# Step 3) Open a new terminal session (see link for detials) and login as the temporary user, 
     sudo login
    $ username: temporary
    $ password:< enter the password>
  
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

