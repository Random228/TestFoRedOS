#!/bin/bash

# Данный скрипт работает на минимальной серверной версии дистрибутива RedOS.x86_64

# Установка и проверка Docker
function INSTALL_DOCKER(){
    # Проверка Docker. Если Docker установлен - включается служба dockerd.
    yum install cri-dockerd.x86_64 -y && service docker start
}

# Создание рабочих директорий и загрузка необходимых компонентов
function GET_FILE(){
    # Загрузка Dockerfile и instapp.bash(подробнее - с.м сам скрипт)
    wget -c https://raw.githubusercontent.com/Random228/TestFoRedOS/main/instapp.bash
    wget -c --directory-prefix=/home/docker https://raw.githubusercontent.com/Random228/TestFoRedOS/main/Dockerfile
    # Загрузка необходимых пакетов и зависимостей для исходного контейнера.
    docker run --rm -v /bin:/bin:ro -v /lib:/lib:ro -v /lib64:/lib64:ro -v /usr:/usr:ro -v /home/docker/nginx:/home/nginx -it registry.red-soft.ru/ubi7/ubi-micro yum install --downloadonly --downloaddir=/home/nginx -y microdnf
}

# Подготовка и сборка Docker container и Docker image
function DOCKER_BUILD(){
    # Включение функции Build Kit
    export DOCKER_BUILDKIT=1
    # Запуск сборки container из Dockerfile
    docker build -t registry.red-soft.ru/ubi7/nginx-micro:test .
    # Сборка Docker image
    docker save registry.red-soft.ru/ubi7/nginx-micro:test > images.tar.xz
     pwd && ls ./ | grep ima*
}

# Проверка пользователя и запуск скрипта
function MAIN(){
    clear
    if [[ `whoami` == "root" ]]; then
    INSTALL_DOCKER
    GET_FILE
    DOCKER_BUILD
    else echo -E "Скрипт должен запускаться пользователем root"
    fi
}
MAIN