# syntax=docker/dockerfile:1
# Образ на котором будет происходить первичная сборка пакетов
FROM registry.red-soft.ru/ubi7/ubi:latest AS builder
# Для удобства, определяем рабочую директорию по умолчанию
WORKDIR /opt/app/nginx
# Копируем корневую систему рабочего образа в рабочую директорию сборочного образа
COPY --from=registry.red-soft.ru/ubi7/ubi-micro:latest ./ .
# Копируем скрипт, ранее загруженные пакеты и зависимости в рабочую директорию сборочного образа
COPY nginx/ ./ \
instapp.bash ./
# Устанавливаем программу для установки зависимостей в рабочий образ
RUN ["dnf","install","cpio","-y"]
# Запускаем скрипт который произведет установку пакетов и зависимостей в рабочий образ
RUN ["bash","./instapp.bash"]

# Начинаем сборку рабочего образа
FROM registry.red-soft.ru/ubi7/ubi-micro:latest
LABEL autor="Badalyan Tigran"
# Копируем подготовленную для установки nginx систему.
COPY --from=builder /opt/app/nginx/ ./
# Запускаем установку nginx версии согласно ТС
RUN microdnf install nginx-1.18.0-1.el7 -y
# создаем пользователя для дальнейшей работы с контейнером согласно ТС
RUN echo "nginx:x:10:0:nginx:/bin/bash" >> /etc/passwd
USER nginx
CMD ["echo","hello"]