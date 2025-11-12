#!/bin/bash

echo "Test"
## Test
result=$(zenity --forms --title="Enter Credentials!" --text="Please enter the credentials to your university account!" --add-entry=Username --add-password=Password --add-list="Domaine" --list-values="UG-STUDENT|GWDG")

exit 1