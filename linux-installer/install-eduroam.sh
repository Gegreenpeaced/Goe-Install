#!/bin/bash

# Getting credentials from parsed parameters
usernameString=$1
passwordString=$2
domaineString=$3
packageManagerString=$4
realHomePathString=$5

# Downloading install script from cat.eduroam.org
cd $HOME/Downloads
wget -O wlan.py "https://cat.eduroam.org/user/API.php?action=downloadInstaller&lang=de&profile=6187&device=linux&generatedfor=user&openroaming=0"

# Executing python file
python3 wlan.py #parse parameters

