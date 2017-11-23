#!/bin/bash
# Jenkins installation wrapper

#
# Currently Supported Operating Systems:
#
#  CentOS 7
#

# Am I root?
if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi

# Detect OS
case $(head -n1 /etc/issue | cut -f 1 -d ' ') in
    Debian)     type="debian" ;;
    Ubuntu)     type="ubuntu" ;;
    *)          type="rhel" ;;
esac

# Check wget
if [ -e '/usr/bin/wget' ]; then
    wget https://raw.githubusercontent.com/stasisha/jenkins/master/jenkins-install-$type.sh -O jenkins-install-$type.sh
        bash jenkins-install-$type.sh $*
        exit
    else
        echo "Error: jenkins-install-$type.sh download failed."
        exit 1
    fi
fi

# Check curl
if [ -e '/usr/bin/curl' ]; then
    curl -O https://raw.githubusercontent.com/stasisha/jenkins/master/jenkins-install-$type.sh
    if [ "$?" -eq '0' ]; then
        bash jenkins-install-$type.sh $*
        exit
    else
        echo "Error: jenkins-install-$type.sh download failed."
        exit 1
    fi
fi

exit
