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
    wget -c --directory-prefix=/home/docker/ https://raw.githubusercontent.com/Random228/TestFoRedOS/NewTest/index.html
    cd /home/docker/ && docker build -t "registry.red-soft.ru/ubi7/nginx-micro:test" .
    fi
}

function SAVE(){
    docker save registry.red-soft.ru/ubi7/nginx-micro:test > image.tar
    tar -cpJf "image.tar.xz" /home/docker/image.tar
    if [[ -f /home/docker/image.tar ]]; then
    rm -f /home/docker/image.tar
    fi
}

function RUN(){
    docker run --name test -d -p 8080:80 registry.red-soft.ru/ubi7/nginx-micro:test
    docker exec -it test nginx -t
    echo -E "Контейнер запущен"
    ls /home/docker/image.tar.xz
}

function MANI(){
    if [[ `id | awk {'print $1'} | grep -wo 0` == 0 ]]; then
    START
    CREATE_CONTAINER
    SAVE
    RUN
    else echo -E "Пользователь должен быть root"
    exit
    fi
}
MANI