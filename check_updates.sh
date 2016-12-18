#!/bin/sh
echo "fish-shell"
cd ~/Desktop/fish-shell
git pull
echo "RETURN VALUE: $? (make clean; autoconf; ./configure --prefix=/usr --sysconfdir=/etc; make)"
cd -
#echo "gTimelog"
#cd ~/Desktop/Insync/Apps/gtimelog
#bzr up
#echo "RETURN VALUE: $?"
#cd -
#echo "Tiny Tiny RSS"
#cd ~/Desktop/Insync/Development/PHP/Tiny-Tiny-RSS
#git pu
#echo "RETURN VAULE: $?"
#cd -
echo "powerline"
cd ~/Desktop/Insync/Apps/powerline
git pull
echo "RETURN VAULE: $?"
cd -
~/Desktop/Insync/Development/PHP/apt-urlcheck/apt-urlcheck.php
#wget -q -O - "http://www.sublimetext.com/dev" | grep "The current Sublime Text 2"
#wget -q -O - "http://www.sublimetext.com/nightly" | grep "The current Sublime Text 2"
wget -q -O - "http://www.sublimetext.com/3" | grep "The latest build is"
wget -q -O - "http://www.sublimetext.com/3dev" | grep "The current Sublime Text 3"
sudo apt update
sudo apt list --upgradable

