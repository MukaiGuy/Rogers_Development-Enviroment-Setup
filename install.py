import os
import platform

system = platform.system()

if system == 'Linux': # Execute a Linux command
    print("This is a Linux machine.")
    os.system('pwd')  # Example command
elif system == 'Darwin': # Execute a macOS command
    print("This is a MacOS machine.")
    os.system('pwd')  # Example command
else:
    print("Unsupported operating system. If you are on a Windows machine please use wsl2. \n Docs: https://learn.microsoft.com/en-us/windows/wsl/install")
