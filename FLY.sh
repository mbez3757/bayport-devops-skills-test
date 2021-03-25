#!/bin/bash

###############################BEGIN DOCKER INSTALLATION###############################################

#Check if Docker is installed
docker_installed=`docker -v`

###If Docker is not installed, then install latest version.
docker_installed=`docker -v`

if [ -z "$docker_installed" ];
then
    #Update the apt package index
    sudo apt-get update
    sudo apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg \
      lsb-release

    docker_url=https://download.docker.com/linux/static/stable/x86_64 &&\
    docker_version=20.10.5 &&\
    curl -fsSL ${docker_url}/docker-${docker_version}.tgz | tar xzvf - --strip-components 1 -C /usr/local/bin docker/docker &&\
    chmod +x /usr/local/bin/docker
fi

###If Docker is installed, stop the docker service and upgrade to the latest version.
if [ ! -z "$docker_installed" ];
then
    #Stop docker service
    sudo systemctl stop docker.service

    #Install the latest version
    docker_version=20.10.5 &&\
    curl -fsSL ${docker_url}/docker-${docker_version}.tgz | tar xzvf - --strip-components 1 -C /usr/local/bin docker/docker &&\
    chmod +x /usr/local/bin/docker
fi

#Enable the docker service
sudo systemctl enable docker.service
#Start docker service
sudo systemctl start docker.service

###############################END DOCKER INSTALLATION###############################################



###############################BEGIN ALFRED CONTAINER###################################################
#Decrypt secret
db_pw=`gpg --batch --passphrase mypassword --decrypt secret.gpg`

#Build the docker image and run the container in detached mode. 
docker build -t ALFRED:0.0.1 .
docker run --name ALFRED  -v /var/lib/mysql:/var/lib/mysql -v /BATCAVE -d  -e MYSQL_ROOT_PASSWORD=$db_pw --rm ALFRED:0.0.1

#Check if the container ALFRED exists. Stop and create the container again
container_exists=`docker inspect -f '{{.State.Running}}' ALFRED || true`
if [ -z "$container_exists" ];then isrunning=false; fi
if $isrunning;
then
   docker stop --time=30 ALFRED
   docker kill ALFRED

   docker run --name ALFRED  -v /var/lib/mysql:/var/lib/mysql -v /BATCAVE -d  -e MYSQL_ROOT_PASSWORD=$db_pw --rm ALFRED:0.0.1
fi
###############################END ALFRED CONTAINER#####################################################


###########################BEGIN WAYNEINDUSTRIES DATABASE###############################################

#Create schema wayneindustries
docker exec -it ALFRED mysql -p -e 'CREATE DATABASE wayneindustries;' 

#Create table fox
docker exec -it ALFRED mysql -p -e 'CREATE TABLE fox (ID INT NOT NULL AUTO_INCREMENT, Name VARCHAR(100));' wayneindustries

#Create table fox
docker exec -it ALFRED mysql -p -e 'INSERT INTO fox (50, "BATMOBILE");' wayneindustries

###########################END WAYNEINDUSTRIES DATABASE###############################################
