#!/bin/bash

function START(){
docker pull registry.red-soft.ru/ubi7/ubi-micro:latest
dir=$( docker image inspect registry.red-soft.ru/ubi7/ubi-micro:latest | grep "diff" | awk {'print $2'} | sed 's/.$//' | sed 's/.$//' | sed 's/^.//' )
yum --installroot="$dir" --releasever=/ --setopt=tsflags=nodocs --setopt=group_package_types=mandatory -y install nginx-1.18.0-1.el7
yum --installroot="$dir" -y clean all
}

function CREATE_CONTAINER(){
    if [[ -d /home/docker/ ]]; then
    wget -c --directory-prefix=/home/docker/ https://raw.githubusercontent.com/Random228/TestFoRedOS/NewTest/nginx.conf
    wget -c --directory-prefix=/home/docker/ https://raw.githubusercontent.com/Random228/TestFoRedOS/NewTest/Dockerfile
    cd /home/docker/ && docker build -t "registry.red-soft.ru/ubi7/nginx-micro:test" .
    fi
}

function RUN(){
    docker run -p 8080:80 registry.red-soft.ru/ubi7/nginx-micro:test
}

function MANI(){
    START
    CREATE_CONTAINER
    RUN
}
MANI