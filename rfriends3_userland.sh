#!/bin/bash
# -----------------------------------------
# install rfriends for userland(ubuntu)
# -----------------------------------------
# 3.6 2024/02/24 remove samba
# 3.8 2024/03/12 crontabC³
# 3.9 2024/03/14 add samba
# 4.0 2024/12/15 github
# -----------------------------------------
ver=4.0
echo
echo rfriends3 for userland ubuntu $ver
echo
# -----------------------------------------
SITE=https://github.com/rfriends/rfriends3/releases/latest/download
SCRIPT=rfriends3_latest_script.zip
user=`whoami`
dir=.
userstr="s/rfriendsuser/${user}/g"
# -----------------------------------------
ar=`dpkg --print-architecture`
bit=`getconf LONG_BIT`
echo
echo architecture is $ar $bit bits .
echo user is $user .
# -----------------------------------------
echo
echo install tools
echo
#
sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get -y install language-pack-ja
export LANG=ja_JP.UTF-8

sudo apt-get -y install \
unzip p7zip-full nano vim \
dnsutils iproute2 tzdata openssh-server \
wget curl atomicparsley \
php-cli php-xml php-zip php-mbstring php-json php-curl php-intl \
ffmpeg

#sudo apt-get -y install chromium-browser
# -----------------------------------------
# timezone
sudo rm /etc/localtime 
sudo echo Asia/Tokyo > /etc/timezone 
sudo dpkg-reconfigure -f noninteractive tzdata

# -----------------------------------------
echo
echo install rfriends3
echo
cd ~/
rm -f $SCRIPT
wget $SITE/$SCRIPT
unzip -q -o $SCRIPT
# -----------------------------------------
echo
echo configure usrdir
echo
mkdir -p /storage/internal/usr2
#mkdir -p /home/$user/tmp/
sed -e ${userstr} $dir/usrdir.ini.skel > /home/$user/rfriends3/config/usrdir.ini
# -----------------------------------------
# cron start
sudo apt-get -y install cron
cd ./
sed -e ${userstr} $dir/crontab.skel > $dir/crontab
crontab $dir/crontab
sudo service cron restart
# -----------------------------------------
# atd not start
sudo apt-get -y remove at
#sudo apt-get -y install at
#sudo service atd restart
# -----------------------------------------
echo
echo configure lighttpd
echo
sudo apt-get -y install lighttpd php-cgi
sudo cp -p /etc/lighttpd/conf-available/15-fastcgi-php.conf /etc/lighttpd/conf-available/15-fastcgi-php.conf.org
sudo sed -e ${userstr} $dir/15-fastcgi-php.conf.skel > $dir/15-fastcgi-php.conf
sudo cp -p $dir/15-fastcgi-php.conf /etc/lighttpd/conf-available/15-fastcgi-php.conf
sudo chown root:root /etc/lighttpd/conf-available/15-fastcgi-php.conf

sudo cp -p /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.org
sudo sed -e ${userstr} $dir/lighttpd.conf.skel > $dir/lighttpd.conf
sudo cp -p $dir/lighttpd.conf /etc/lighttpd/lighttpd.conf
sudo chown root:root /etc/lighttpd/lighttpd.conf

mkdir -p /home/$user/lighttpd/uploads/
sudo lighttpd-enable-mod fastcgi
sudo lighttpd-enable-mod fastcgi-php

#sudo systemctl restart lighttpd
sudo service lighttpd restart
# -----------------------------------------
echo
echo configure samba
echo
sudo apt-get -y install samba
sudo mkdir -p /var/log/samba
#sudo chown root.adm /var/log/samba

mkdir /home/$user/smbdir
chmod 755 /home/$user/smbdir
mkdir /home/$user/smbdir/usr2
chmod 755 /home/$user/smbdir/usr2

sudo cp -p /etc/samba/smb.conf /etc/samba/smb.conf.org
sed -e ${userstr} $dir/smb.conf.skel > $dir/smb.conf.add

grep -q 'smbdir' /etc/samba/smb.conf
if [ $? -ne 0 ]; then
  sudo cat $dir/smb.conf.add >> /etc/samba/smb.conf
fi

#sudo systemctl restart smbd nmbd
#sudo service smbd restart
sudo smbd -D -p 4445
# -----------------------------------------
# start
grep -q 'service cron' /support/startSSHServer.sh
if [ $? -ne 0 ]; then
  sudo echo '# add' >> /support/startSSHServer.sh
  sudo echo 'service cron restart' >> /support/startSSHServer.sh
  sudo echo 'service lighttpd restart' >> /support/startSSHServer.sh
  sudo echo 'smbd -D -p 4445' >> /support/startSSHServer.sh
fi
# -----------------------------------------
#ip=`ip -4 -br a`
ip=`hostname -I | cut -f1 -d" "`
echo
echo ip address is $ip
echo
echo visit rfriends at http://${ip}:8000
echo
echo access samba at smb://${ip}:4445
echo if windows then use Owlfiles
echo
# -----------------------------------------
# finish
# -----------------------------------------
echo enjoy!
# -----------------------------------------
