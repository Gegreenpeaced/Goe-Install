#!/bin/bash
#### Generelles Startup Script

## Testing Area


### Declaring Functions
## General Functions
# Get Packagemanager
get_Packagemanager() {
    if command -v apt > /dev/null 2>&1; then
    echo "Package Manager is 'apt'! Refreshing Package Sources..."
    sudo apt update
    echo "apt"
    bashProfileName=.profile
    elif command -v dnf > /dev/null 2>&1; then
    echo "Package Manager is 'dnf'..."
    bashProfileName=.bash_profile
    echo "dnf"
    elif command -v yum > /dev/null 2>&1; then
    echo "Package Manager is 'yum'..."
    echo "yum"
    elif command -v zypper > /dev/null 2>&1; then
    echo "Package Manager is 'zypper'..."
    echo "zypper"
    elif command -v pacman > /dev/null 2>&1; then
    echo "Package Manager is 'pacman'..."
    echo "pacman"
    else
    echo "No Package Manager found... Aborting!"
    exit -1
    fi 
    }

# Get Homepath
get_Homepath () {
    cd ~/Home
    echo $HOME
}
# Install Package
install_package() {
    echo "Installing $1..."
    sudo $packageManager install -y $1
}
# Select Desktop Enviroment
select_DE() {
    returnDE=$(whiptail --title "Setup: Desktop Enviroment" --radiolist \
    "Please select (SPACE) your Desktop Enviroment and confirm with (OK)" 20 82 4 \
    "GNOME" "GNOME, Standard Desktop Enviroment know for simplicity" OFF \
    "KDE" "KDE Plasma, Desktop Enviroment know for its costumeisabilty" OFF \
    "N/A" "Other Desktop Enviroments oder Unknown" ON 3>&1 1>&2 2>&3)
    exitstatus=$?
    # Check correct answer
    if [ $exitstatus == 0 ]; then
        echo $returnDE
    else
    # Error
        echo "User selected Cancel."
        exit 0
    fi
}

## User specific functions
# Set User Credentials
set_UserCred() {
    # Prepare while loop
    exitBool=false

    until [ $exitBool = "true" ]
    do
    echo "test"
    # Declaring functions
    credUsername=""
    credPass=""
    credDomaine=""
    credDialogString=""

    # Define Overload String
    credMenuDomaineString=$(head -n 1 domains.domains)

    # Set correct Dialog to DE
    case $stdDE in
    "GNOME")
        credDialogString=$(zenity --forms --title="User Setup: Credentials" --text="Please enter the credentials to your university account!" --add-entry=Username --add-password=Password --add-list=Domaine --list-values=$credMenuDomaineString)
    ;;
    "KDE")
        echo "Unsupported"
        exit -1
    ;;
    "N/A")
        echo "Unsupported"
        exit -1
    ;;
    esac

    # Recieve Credentials
    # Split the result string by "|"
    readarray -d "|" -t credarr <<< "$credDialogString"

    # Test if array fiels are empty
    if [ ! ${credarr[0]} = "" ] || [ ! ${credarr[1]} = "" ] || [ ! ${credarr[2]} = "" ]; then

    # Set User Credentials
    credUsername=${credarr[0]}
    credPass=${credarr[1]}
    credDomaine=${credarr[2]}

    # Set Value to escape while Loop
    exitBool=true

    # If on is empty, ask if they want to retry
    else
    # Generate Dialog
    zenity --question --title="Error!" --text="One of the Form Inputs is Null. Do you want to retry entering your credentials?"
    if [ $? = 1 ]; then
    echo "Not retrying... Aborting!"
    exit -1
    fi
    fi
    done
}



### Startup
## System Startup
# Set Packagemanager
packMan=$(get_Packagemanager)

# Set Homepath
realHP=$(get_Homepath)

# Testing if whiptail dialog is installed
if [ ! $(which whiptail) = "/usr/bin/whiptail" ]; then
install_package "whiptail"
else
echo "Whiptail installed"
fi
echo "test"
# Ask for installed DE
stdDE=$(select_DE)
echo $stdDE

## User Startup
# Check what DE is installed and if not installed then install appropriate dialog service
case $stdDE in

    "GNOME")
    # Test if zenity is installed
    if [ ! $(which zenity) = "/usr/bin/zenity" ]; then
    echo "Gnome Dialog zenity not installed! Installing..."
    install_package "zenity"
    else
    echo "Zenity already installed"
    fi
    ;;
    "KDE")
    if [ ! $(which kdialog) = "/usr/bin/kdialog" ]; then
    echo "KDE Dialog kdialog not installed! Installing..."
    install_package "kdialog"
    else
    echo "kdialog already installed"
    fi
    ;;
esac


### Initial User Setup
# Getting User Credentials
set_UserCred

# Ask what they want to do
