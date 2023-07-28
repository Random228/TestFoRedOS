# syntax=docker/dockerfile:1
# Используем необходимый образ.
FROM registry.red-soft.ru/ubi7/ubi-micro:latest
LABEL autor="Badalyan Tigran"
# Копируем конфиг nginx.
COPY nginx.conf /etc/nginx/nginx.conf
# Настраиваем. В основном, меняем владельца необходимых файлов и директорий на пользователя nginx.
RUN chown -R nginx:nginx /etc/nginx \
&& chmod -R g+w /etc/nginx \
&& rm -rf /var/log/nginx/ \
&& mkdir -p /var/log/nginx \
&& touch /var/log/nginx/error.log \
&& touch /var/log/nginx/access.log \
&& chown -R nginx:nginx /var/log/nginx \
&& touch /tmp/nginx.pid \
&& chown -R nginx /tmp/nginx.pid \
&& mkdir -p /usr/share/nginx/html \
&& sed -i 's/\/var\/lib\/nginx\:\/sbin\/nologin/\/var\/lib\/nginx\:\/bin\/bash/g' etc/passwd
# Копируем index для сервера.
COPY index.html /usr/share/nginx/html
# Ищем файлы связанные с nginx, меняем их группу и даем доступ на работу с ними.
RUN find / -name *nginx* -exec chgrp -R nginx {} \;
RUN find / -name *nginx* -exec chmod -R g=rwx {} \;
# Указываем на необходимость открытия порта хоста.
EXPOSE 8080
# Далее, пользователем nginx запускаем сам Nginx. Вход будет осуществляется пользователем nginx. 
USER nginx
CMD ["nginx","-g","daemon off;"]