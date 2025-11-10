#!/bin/bash

### Setting User Variables
# Getting User Credentials for Session
echo "To install the printing services, please enter your User Credentials"

echo "Enter your Username"
read username

echo "Enter your Password"
read -s password

echo "Enter your Domaine"
read domaine

## Setting Enviroment Variables
# Identifying Package Manager
echo "Identifying Package Manager..."
if command -v apt > /dev/null 2>&1; then
    packageManager=apt
    echo "Package Manager is 'apt'! Refreshing Package Sources..."
    sudo apt update
    bashProfileName=.profile
elif command -v dnf > /dev/null 2>&1; then
    echo "Package Manager is 'dnf'..."
    packageManager=dnf
    bashProfileName=.bash_profile
elif command -v yum > /dev/null 2>&1; then
    packageManager=yum
    echo "Package Manager is 'yum'..."
elif command -v zypper > /dev/null 2>&1; then
    packageManager=zypper
    echo "Package Manager is 'zypper'..."
elif command -v pacman > /dev/null 2>&1; then
    packageManager=pacman
    echo "Package Manager is 'pacman'..."
else
    echo "No Package Manager found... Aborting!"
    exit 1
fi

# Get Real User Home Path
echo "Setting Home User Path Variable..."
realHomePath=$HOME

### Fresh Install (if necessary) of Utils without java
# Installing all other nesessary packages
echo "Installing all nesessary packages..."
sudo $packageManager install -y cups ghostscript cifs-utils smbclient wget


### Deleting all old Files and Services
# Configure CUPS Service
echo "Stopping CUPS Service..."
sudo systemctl stop cups

echo "Deleting outdated Printers and drivers..."
sudo rm /etc/cups/printers.conf
sudo rm -r /etc/cups/ppd/*

echo "Starting Cups again"
sudo systemctl start cups

## Deleting old papercut-client files
# Testing if papercut-client is already installed 
echo "Testing if papercut-client is installed..."
pcClientDIR="$realHomePath/.local/papercut-linux/"
if [ -d "$pcClientDIR" ]; then

# Delete old papercut-client
echo "Papercut-client already installed. Deleting..."
sudo rm -r $realHomePath/.local/papercut-linux/
else
echo "Papercut-client not installed!"
fi

# Make Download Directory 
echo "Creating Papercut Client Path..."
mkdir $realHomePath/.local/papercut-linux/

### Installing CUPS Printers
## Downloading Drivers
# Change to Download Directory and download
echo "Downloading Printer Drivers..."
cd $realHomePath/Downloads
#smbget --recursive --verbose --user $domaine'\'$username%$password smb://print.student.uni-goettingen.de/pcclient/linux-drivers
wget -O download.zip.temp https://owncloud.gwdg.de/index.php/s/LdpQQhILQ8FtAJp/download
# Unzipping
echo "Extracting Printer Drivers"
unzip -o download.zip.temp
# Removing tempfile
rm download.zip.temp


## Adding Printers to CUPS
# Adding Follow-Me B/W Printer
echo "Adding Uni-Follow-Me to CUPS..."
lpadmin -p Uni-Follow-Me -E -v "smb://$domaine\'$username':'$password'@print-win.student.uni-goettingen.de/Follow-Me" -P Generic_PostScript_Uni_Goe_Follow_Me.ppd
#Normalerweise muss das an den lpadmin befehl noch dran: $realHomePath/Downloads/Generic_PostScript_Uni_Goe_Follow_Me_A3.ppd
# Adding Follow-Me Color Printer
echo "Adding Uni-Follow-Me-Farbe to CUPS..."
lpadmin -p Uni-Follow-Me-Farbe -E -v "smb://$domaine\'$username':'$password'@print-win.student.uni-goettingen.de/Follow-Me-Farbe" -P Generic_PostScript_Uni_Goe_Follow_Me_Farbe.ppd

# Adding Follow-Me A3 Printer
echo "Adding Uni-Follow-Me-A3 to CUPS..."
lpadmin -p Uni-Follow-Me-A3 -E -v "smb://$domaine\'$username':'$password'@print-win.student.uni-goettingen.de/Follow-Me-A3" -P Generic_PostScript_Uni_Goe_Follow_Me_A3.ppd

# Adding Follow-Me bcipls79 Printer
echo "Do you want to Install the SUB MED Poster Plotter (bcipls79) ? (y/n)"
read boolInstallBcipls79
if [ $boolInstallBcipls79 = 'y' ]; then
echo "Installing Poster Plotter 'bcipls79' to CUPS..."
lpadmin -p Uni-bcipls79 -E -v "smb://$domaine\'$username':'$password'@print-win.student.uni-goettingen.de/bcipls79" -P HP-T1700_Uni-Goe_Posterdrucker.ppd
else
echo "NOT installing LRC SUB Poster Plotter (bcipls79)!"
fi

# Adding Follow-Me mcipls79 Printer
echo "Do you want to Install the LRC MED Poster Plotter (mcipls79) ? (y/n)"
read boolInstallMcipls79
if [ $boolInstallMcipls79 = 'y' ]; then
echo "Installing Poster Plotter 'mcipls79' to CUPS..."
lpadmin -p Uni-mcipls79 -E -v "smb://$domaine\'$username':'$password'@print-win.student.uni-goettingen.de/mcipls79" -P HP-T1700_Uni-Goe_Posterdrucker.ppd
else
echo "NOT installing LRC MED Poster Plotter (mcipls79)!"
fi


# Adding Follow-Me pcipls Printer
echo "Do you want to Install the BB Physik Poster Plotter (pcipls) ? (y/n)"
read boolInstallPcipls
if [ $boolInstallPcipls = 'y' ]; then
echo "Installing Poster Plotter 'pcipls' to CUPS..."
lpadmin -p Uni-pcipls -E -v "smb://$domaine\'$username':'$password'@print-win.student.uni-goettingen.de/pcipls" -P HP-T1700_Uni-Goe_Posterdrucker.ppd
else
echo "NOT installing BB Physik Poster Plotter (pcipls)!"
fi

## Deleting Printer Driver Files
echo "Cleaning up Printer Driver Downloads..."
rm HP-T1700_Uni-Goe_Posterdrucker.ppd
rm Generic_PostScript_Uni_Goe_Follow_Me_Farbe.ppd
rm Generic_PostScript_Uni_Goe_Follow_Me_A3.ppd
rm Generic_PostScript_Uni_Goe_Follow_Me.ppd


### Install/Copy Papercut Client files to location
## Installing Java
# Testing if sdk man is not installed 
echo "Testing if SDKMAN is installed..."
sdkManDIR="$realHomePath/.sdkman"
if [ ! -d "$sdkManDIR" ]; then
# Installing and configurating SDK Man
echo "SDKMAN not installed. Installing..."
sudo $packageManager install -y curl
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
echo "SDKMAN installed!"
else
echo "SDKMAN already installed"
fi 

# Including SDKMAN
echo "Including SDKMAN Config..."
source $realHomePath/$bashProfileName
sdk update

# Check if correct java Version is installed
if [[ $(sdk current java) = "Using java version 25-zulu" ]]; then
echo "Correct Java Version installed: 25-zulu"

# Setting correct java Version
else
mkdir $realHomePath/.local/papercut-linux/jre-25-zulu
sdk install java 25-zulu $realHomePath/.local/papercut-linux/jre-25-zulu
fi

# Downloading papercut-client from university SAMBA Fileserver
# Change to Download Directory and download
cd $realHomePath/.local/papercut-linux
echo "Downloading Papercut Client..."
smbget --recursive --verbose --user $domaine'\'$username%$password smb://print.student.uni-goettingen.de/pcclient/linux

# Write .desktop file
echo "Creating Papercut Client .desktop File..."
echo "[Desktop Entry]

# The type as listed above
Type=Application

# The version of the desktop entry specification to which this file complies
Version=1.0

# The name of the application
Name=Papercut Client

# A comment which can/will be used as a tooltip
Comment=Client to print at the University of Göttingen.

# The path to the folder in which the executable is run
Path=$realHomePath/.local/papercut-linux/

# The executable of the application, possibly with arguments.
Exec=$realHomePath/.local/papercut-linux/start.sh

# The name of the icon that will be used to display this entry
Icon=$realHomePath/.local/papercut-linux/lib/icon-toast-notify.png

# Describes whether this application needs to be run in a terminal or not
Terminal=false

# Describes the categories in which this entry should be shown
Categories=System;Printing;Education" > $realHomePath/.local/share/applications/papercut.desktop

# Setting Permissions
chmod +x $realHomePath/.local/share/applications/papercut.desktop

# Create Papercut client.properties file
echo "Configurating Papercut-Client..."

# Append text to start file
echo "
#!/bin/bash

# Including SDKMAN
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Setting correct java version for "one-time" use
sdk default java 25-zulu

# Starting normal Programm
exec ./pc-client-linux.sh
" > $realHomePath/.local/papercut-linux/start.sh

# Make Statupscript Executable
chmod +x $realHomePath/.local/papercut-linux/start.sh

# Change Back to a Directory where no harm can be caused
cd $realHomePath/Downloads

# Ask if Client should start on startup
echo "Do you want to enable papercut-client to start on boot? (y/n)"
read startonbootBool
if [ $startonbootBool = y ]; then
echo "Creating systemd file..."
echo "
[Unit]
Description=Starts printing service of papercut-client
After=cups.service

[Service]
ExecStart=$realHomePath/.local/papercut-linux/start.sh

[Install]
WantedBy=default.target" > /etc/systemd/system/papercut.service

# Setting correct permissions
echo "Setting permissions..."
sudo chmod 744 $realHomePath/papercut-linux/start.sh
sudo chmod 664 /etc/systemd/system/papercut.service

# Enabling Service
echo "Starting Service..."
sudo systemctl daemon-reload
sudo systemctl enable papercut.service
else
fi

# finishing
echo "DONE!"

# rebooting
echo "PC needs to reboot. Do you want to reboot now? (y/n)"
read rebootBool
if [ $rebootBool = y ]; then
sudo reboot now
else
echo "Reboot asap!"
fi

# exiting clean
exit 0
