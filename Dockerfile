# syntax=docker/dockerfile:1
FROM registry.red-soft.ru/ubi7/ubi-micro:latest
LABEL autor="Badalyan Tigran"
RUN find / -name *nginx* -exec chgrp -R nginx {} \;
RUN find / -name *nginx* -exec chmod -R g=rwx {} \;
RUN chmod -R g=rwx /var/log/nginx
USER nginx
CMD nginx -g "daemon off;"