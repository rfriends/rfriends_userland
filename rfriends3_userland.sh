#!/bin/bash
# -----------------------------------------
# install rfriends for userland(ubuntu)
# -----------------------------------------
# 3.8 2024/03/12 crontab
# 3.9 2024/03/14 add samba
# 4.0 2024/12/15 github
# 4.1 2025/01/05 fix
# -----------------------------------------
ver=4.1
echo
echo rfriends3 for userland ubuntu $ver
echo
# -----------------------------------------
sudo apt-get -y update
sudo apt-get -y install inet-tools
sudo apt-get -y install language-pack-ja
export LANG=ja_JP.UTF-8
# -----------------------------------------
# timezone
sudo cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
date
# -----------------------------------------
echo
echo install rfriends3,lighttpd,cron
echo
optlighttpd="on"
optsamba="off"
#optsambaport="4445"
export optlighttpd
export optsamba
export optsambaport
cd ~/
git clone https://github.com/rfriends/rfriends_ubuntu.git
cd rfriends_ubuntu
sh ubuntu_install.sh 2>&1 | tee ubuntu_install.log
# -----------------------------------------
#ip=`ip -4 -br a`
ifconfig | grep inet
echo
echo visit rfriends at http://ipアドレス:8000
echo
#echo access samba at smb://ipアドレス:4445
#echo if windows then use Owlfiles
#echo
echo caution!!! atd is not work
echo
# -----------------------------------------
# finish
# -----------------------------------------
echo enjoy!
# -----------------------------------------
