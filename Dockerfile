# syntax=docker/dockerfile:1
FROM registry.red-soft.ru/ubi7/ubi-micro:latest
LABEL autor="Badalyan Tigran"

COPY nginx.conf /etc/nginx/nginx.conf

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

COPY index.html /usr/share/nginx/html

RUN find / -name *nginx* -exec chgrp -R nginx {} \;
RUN find / -name *nginx* -exec chmod -R g=rwx {} \;

EXPOSE 8080

STOPSIGNAL SIGQUIT

USER nginx
CMD ["nginx","-g","daemon off;"]