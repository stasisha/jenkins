#!/bin/bash

read -p 'Would you like to use https over nginx? [y/n]: ' nginx_answer

#install lib
yum install java-openjdk wget -y

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins -y

systemctl start jenkins.service
systemctl enable jenkins.service
