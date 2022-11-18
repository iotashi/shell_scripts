#!/bin/bash

#---------------------------------------------------------------------------------------#
# @Autor : Cedric Ngandjouo                                                             #
# Description : This is the script that will take care of the installation              #
# of Java, Jenkins server and some utilitiess                                           #
# Date : 10/17/2022                                                                     #
#---------------------------------------------------------------------------------------#


## Recover the ip address and update the server
IP=$(hostname -I | awk '{print $2}')
echo "START - install jenkins - "$IP
echo "=====> [1]: updating ...."
sudo yum update -y -q > /dev/null

## Prerequisites tools(curl, wget, ...) for Jenkins

echo "=====> [2]: install prerequisite tools for Jenkins"

# Install vim 
sudo yum install vim -y 

# Install wget
sudo yum install wget -y 

# Install sshpass
sudo yum install sshpass -y

# Install gnupg2
sudo yum install gnupg2 -y

# Install openssl
sudo yum install openssl -y

# Install curl:
sudo yum install curl -y

# Remove default version of java:
sudo yum remove java* -y

# install the OpenJDK version of Java 11:
sudo yum install java-11-openjdk -y

# Jenkins uses 'ant' so let's make sure it is installed:

# Let's now install Jenkins:
echo "===== =================> [3]: Choose Java 11 for Jenkins installation ...."
sudo update-alternatives --set java /usr/lib/jvm/java-11-openjdk-11.0.16.0.8-1.el7_9.x86_64/bin/java
java -version

echo "=====> [3]: installing Jenkins ...."
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins

echo "=====> [4]: updating server after jenkins installation ...."
sudo yum update -y

echo "=====> [5]: Start and Enable Jenkins Daemon ...."
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "=====> [6]: Opening Jenkins port on Firewall ...."
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
sudo firewall-cmd --reload

echo "END - install jenkins"