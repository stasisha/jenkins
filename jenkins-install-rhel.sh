#!/bin/bash

read -p 'Would you like to use SWAP? [y/n]: ' swap
read -p 'Would you like to use https over nginx? [y/n]: ' nginx_answer

#install lib
yum install java-openjdk wget -y

#creating SWAP
if [ "$swap" == 'y' ] || [ "$swap" == 'Y'  ]; then
    echo "Creating 4G SWAP file. This can take few minutes..."
    fallocate -l 4G /swapfile
    dd if=/dev/zero of=/swapfile count=4096 bs=1MiB
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile   swap    swap    sw  0   0' >> /etc/fstab
fi

#install jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins -y
systemctl start jenkins.service
systemctl enable jenkins.service

ip=$(curl ifconfig.co)
location=$ip":8080"

#install nginx
if [ "$nginx_answer" == 'y' ] || [ "$nginx_answer" == 'Y'  ]; then
  yum install nginx -y
  wget https://raw.githubusercontent.com/stasisha/jenkins/master/rhel/nginx.conf  -O /etc/nginx/nginx.conf
  mkdir -p /etc/nginx/ssl
  openssl req -new -newkey rsa:4096 -days 1825 -nodes -x509 -subj "/C=UA/ST=KV/L=Kiev/O=St/CN=jenkins.example.com" -keyout /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.crt
  systemctl start nginx
  systemctl enable nginx
  setsebool -P httpd_can_network_connect 1
  location=$ip
fi

curl -s localhost:8080 > /dev/null
pwd="$(cat /var/lib/jenkins/secrets/initialAdminPassword)"

echo '=================================================================='
echo
echo "    Congratulations, you have just successfully installed Jenkins"
echo
echo "    https://$location"
echo "    Administrator password: $pwd"
echo
echo '=================================================================='
echo
