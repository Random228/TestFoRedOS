#!/bin/bash

#Данный скрипт запускается на этапе сборки docker container в режиме multi-stage
#Его задача - чтение имен rpm пакетов из текущей директории и их установка в текущую директорию

#Перенаправление динамического вывода компанды pwd в переменную
pwd=`pwd`
#Запуск цикла проверки и установки. 
#1) Поиск rpm пакетов в текущей директории
for list in `ls $pwd | grep rpm`; do
#2) Если найдены rpm пакеты - производится их локальная установка в текущую директорию
if [[ -n $list ]]; then
rpm2cpio $list | cpio -idmv
#3) Если rpm пакеты не найдены, то скрипт (соответственно и сборка) завершит работу
else exit
fi
done
#4) После успешной установки - удаление rpm пакетов, для облегчения образа.
if [[ -n $list ]] then
rm -rf *rpm
fi