#!/bin/bash

docker pull registry.red-soft.ru/ubi7/ubi-micro:latest
dir=$( docker image inspect registry.red-soft.ru/ubi7/ubi-micro:latest | grep "diff" | awk {'print $2'} | sed 's/.$//' | sed 's/.$//' | sed 's/^.//' )
yum --installroot="$dir" --releasever=/ --setopt=tsflags=nodocs --setopt=group_package_types=mandatory -y install nginx-1.18.0-1.el7
yum --installroot="$dir" -y clean all