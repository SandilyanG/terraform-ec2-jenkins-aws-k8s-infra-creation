#!/bin/bash

# System update block: refreshes the package index so later installs use current metadata.
sudo yum update
# Jenkins repository block: adds the official Jenkins package repository to the system.
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
# Jenkins signing key block: imports the repository key so package verification succeeds.
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
# Upgrade block: applies available package upgrades before installing Jenkins dependencies.

sudo yum upgrade -y
#sudo yum install jenkins java-1.8.0-openjdk-devel -y
#sudo amazon-linux-extras install java-openjdk11
#Java 17 installed and old Java versions commented out
# Java runtime block: installs Amazon Corretto 17 for Jenkins and build tooling.
sudo dnf install java-17-amazon-corretto-devel -y
# Developer tools block: installs Git and Node.js for build and integration tasks.
sudo yum install git -y
sudo yum install nodejs npm -y
# Maven repository block: adds the Apache Maven repository used for Java builds.
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
# Repository compatibility block: updates the repo file to match the target release version.
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
# Maven install block: installs Apache Maven for Java project builds.
sudo yum install -y apache-maven
# Java selection block: sets Java 17 as the default runtime on the host.
sudo update-alternatives --set java /usr/lib/jvm/java-17-amazon-corretto.x86_64/bin/java
# Jenkins install block: installs the Jenkins service package.
sudo yum install jenkins -y
# Jenkins port block: changes the Jenkins service port to 8081 before startup.
sudo sed -i -e 's/Environment="JENKINS_PORT=[0-9]\+"/Environment="JENKINS_PORT=8081"/' /usr/lib/systemd/system/jenkins.service
# Service reload block: reloads systemd so the Jenkins port change takes effect.
sudo systemctl daemon-reload
# Jenkins start block: starts Jenkins immediately and verifies it is running.
sudo systemctl start jenkins
sudo systemctl status jenkins
# AWS CLI block: downloads and installs AWS CLI v2 for cloud administration.
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
# Archive tools block: installs unzip, then extracts and installs AWS CLI.
sudo yum install unzip -y
sudo unzip awscliv2.zip  
sudo ./aws/install
# ZAP block: installs OWASP ZAP for security testing.
sudo wget https://github.com/zaproxy/zaproxy/releases/download/v2.14.0/ZAP_2_14_0_unix.sh
sudo chmod +x ZAP_2_14_0_unix.sh 
sudo ./ZAP_2_14_0_unix.sh -q
# kubectl block: downloads and installs the Kubernetes CLI.
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
sudo cp kubectl /usr/local/bin/
# eksctl block: downloads and installs the EKS cluster management CLI.
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
# Docker block: installs Docker and configures Jenkins and the current user for container builds.
sudo yum install docker -y
sudo usermod -aG docker $USER
sudo newgrp docker
sudo usermod -aG docker jenkins
sudo newgrp docker
# Service restart block: restarts Jenkins and starts Docker so both services are ready.
sudo service jenkins restart
sudo systemctl daemon-reload
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
# Utility block: installs jq for JSON processing during administration or pipeline steps.
sudo yum install jq -y
