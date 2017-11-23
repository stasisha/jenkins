#!/bin/bash

read -p 'Would you like to use https over nginx? [y/n]: ' nginx_answer

#install lib
yum install java-openjdk wget -y

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins -y

systemctl start jenkins.service
systemctl enable jenkins.service

if [ "$nginx_answer" == 'y' ] || [ "$nginx_answer" == 'Y'  ]; then
  yum install nginx -y
  wget https://raw.githubusercontent.com/stasisha/jenkins/master/rhel/nginx.conf  -O /etc/nginx/nginx.conf
  mkdir -p /etc/nginx/ssl
  openssl req -new -newkey rsa:4096 -days 1825 -nodes -x509 -subj "/C=UA/ST=KV/L=Kiev/O=St/CN=teamcity.example.com" -keyout /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.crt
  systemctl start nginx
  systemctl enable nginx
  setsebool -P httpd_can_network_connect 1
fi
