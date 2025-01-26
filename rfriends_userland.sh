#!/bin/bash
# -----------------------------------------
# install rfriends for userland(ubuntu)
# -----------------------------------------
# 3.8 2024/03/12 crontab
# 3.9 2024/03/14 add samba
# 4.0 2024/12/15 github
# 4.1 2025/01/05 fix
# 4.2 2025/01/27 renew
# -----------------------------------------
ver=4.2
echo
echo rfriends3 for userland ubuntu $ver
echo
# -----------------------------------------
sudo apt-get -y update
sudo apt-get -y install net-tools
sudo apt-get -y install language-pack-ja
export LANG=ja_JP.UTF-8
# -----------------------------------------
# timezone
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
date
# -----------------------------------------
echo
echo install rfriends3,lighttpd,cron
echo
export distro=ubuntu
export cmd="apt-get -y install"
export user=userland
export group=userland
export homedir=/home/$user
export optlighttpd="on"
export optsamba="off"
#export optsambaport="4445"
cd ~/
git clone https://github.com/rfriends/rfriends3_core.git
rm -rf rfriends3_core
cd rfriends3_core
sh common.sh 2>&1 | tee common.log
# -----------------------------------------
mkdir -p /storage/internal/usr2/
cat <<EOF > $homedir/rfriends3/config/usrdir.ini
usrdir = "/storage/internal/usr2/"
tmpdir = "$homedir/tmp/"
EOF
# stop atd
sudo service atd stop
# -----------------------------------------
#ip=`ip -4 -br a`
#ifconfig | grep inet
hostname -I
echo
echo visit rfriends at http://ipアドレス:8000
echo
#echo access samba at smb://ipアドレス:4445
#echo if windows then use Owlfiles
#echo
echo caution!!! atd is stopped
echo
# -----------------------------------------
# finish
# -----------------------------------------
echo enjoy!
# -----------------------------------------
