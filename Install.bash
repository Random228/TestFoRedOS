#!/bin/bash

#Данный скрипт работает на минимальной серверной версии дистрибутива RedOS.x86_64

#Установка и проверка Docker
function INSTALL_DOCKER(){
    #Устанавливаем Docker
    yum install cri-dockerd.x86_64
    #Проверка Docker. Если Docker установился - включается служба dockerd
    if [[ `docker --version | awk {'print $0'}` == "Docker" ]]; then
    systemctl start docker
    #Если произошёл сбой в установке, мы получаем ошибку
    else echo -E "Возникла ошибка при установке Docker"
    fi
}

#Создание рабочих директорий и загрузка необходимых компонентов
function GET_FILE(){
    #Создание рабочей директории
    mkdir /home/docker/nginx
    #Загрузка Dockerfile и instapp.bash(подробнее - с.м сам скрипт)
    wget -c --directory-prefix=/home/docker/nginx #тут ссылка на скрипт
    wget -c --directory-prefix=/home/docker/nginx #тут ссылка на dockerfile
    #Загрузка необходимых пакетов и зависимостей для исходного контейнера.
    docker run --rm -v /bin:/bin:ro -v /lib:/lib:ro -v /lib64:/lib64:ro -v /usr:/usr:ro -v /home/docker/nginx:/home/nginx -it registry.red-soft.ru/ubi7/ubi-micro yum install --downloadonly --downloaddir=/home/nginx -y microdnf
}

#Подготовка и сборка Docker container и Docker image
function DOCKER_BUILD(){
    #Запуск сборки container из Dockerfile
    docker build -t registry.red-soft.ru/ubi7/nginx-micro:test .
    #Сборка Docker image
    docker save registry.red-soft.ru/ubi7/nginx-micro:test > images.tar.xz
}

#Проверка пользователя и запуск скрипта
function MAIN(){
    if [[ `whoami` == "root" ]]; then
    INSTALL_DOCKER
    GET_FILE
    DOCKER_BUILD
    else echo -E "Скрипт должен запускаться пользователем root"
    fi
}