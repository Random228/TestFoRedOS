#!/bin/bash

# Проверка, установлен ли Docker. 
function CHECK_DOCKER(){
    if [[ `docker -v  2>/dev/null | awk {'print $1,$2'}` == "Docker version" ]]; then 
    echo "Docker установлен"
    else yum install cri-dockerd.x86_64 -y && service docker start
    fi
}

# Скачаем необходимый образ и установим в него nginx используя средства хоста.
function START(){
    # Скачиваем образ.
docker pull registry.red-soft.ru/ubi7/ubi-micro:latest
    # Установим переменную, определяющуюю системную директорию образа.
dir=$( docker image inspect registry.red-soft.ru/ubi7/ubi-micro:latest | grep "diff" | awk {'print $2'} | sed 's/.$//' | sed 's/.$//' | sed 's/^.//' )
    # Выполним установку nginx-1.18.0-1.el7 в образ.
yum --installroot="$dir" --releasever=/ --setopt=tsflags=nodocs --setopt=group_package_types=mandatory -y install nginx-1.18.0-1.el7
    # Удалим остаточные файлы
yum --installroot="$dir" -y clean all
}

# Создание готового образа с установкой необходимых конфигураций.
function CREATE_CONTAINER(){
    # Проверка существования рабочей директории, о которой говорилось в README.
    if [[ -d /home/docker/ ]]; then
    # Скачивание необходимых файлов.
    wget -c --directory-prefix=/home/docker/ https://raw.githubusercontent.com/Random228/TestFoRedOS/NewTest/nginx.conf
    wget -c --directory-prefix=/home/docker/ https://raw.githubusercontent.com/Random228/TestFoRedOS/NewTest/Dockerfile
    wget -c --directory-prefix=/home/docker/ https://raw.githubusercontent.com/Random228/TestFoRedOS/NewTest/index.html
    # Тегированная сборка образа.
    cd /home/docker/ && docker build -t "registry.red-soft.ru/ubi7/nginx-micro:test" .
    else
    mkdir -p /home/docker
    wget -c --directory-prefix=/home/docker/ https://raw.githubusercontent.com/Random228/TestFoRedOS/NewTest/nginx.conf
    wget -c --directory-prefix=/home/docker/ https://raw.githubusercontent.com/Random228/TestFoRedOS/NewTest/Dockerfile
    wget -c --directory-prefix=/home/docker/ https://raw.githubusercontent.com/Random228/TestFoRedOS/NewTest/index.html
    cd /home/docker/ && docker build -t "registry.red-soft.ru/ubi7/nginx-micro:test" .
    fi
}

# Сохранение образа в готовый tar.xz архив.
function SAVE(){
    # Сохранение готового образа.
    docker save registry.red-soft.ru/ubi7/nginx-micro:test > image.tar
    # Создание tar.xz архива.
    tar -cpJf "image.tar.xz" /home/docker/image.tar
    # Проверка наличия остаточных файлов и их удаление.
    if [[ -f /home/docker/image.tar ]]; then
    rm -f /home/docker/image.tar
    fi
}

# Запуск и тестирование контейнера.
function RUN(){
    # Запуск контейнера.
    docker run --name nginx-web -d -p 8080:80 registry.red-soft.ru/ubi7/nginx-micro:test
    # Показываем работающий процесс
    docker ps
    # Выполнение команды для проверки работы Nginx.
    docker exec -it nginx-web nginx -t
    # Показываем где лежит сохраненный образ.
    ls /home/docker/image.tar.xz
}


function MANI(){
    clear
    # Проверка пользователя который запускает скрипт с использование id вместо whoami.
    if [[ `id | awk {'print $1'} | grep -wo 0` == 0 ]]; then
    CHECK_DOCKER
    clear
    START
    clear
    CREATE_CONTAINER
    clear
    SAVE
    clear
    RUN
    else echo -E "Пользователь должен быть root"
    exit
    fi
}
MANI