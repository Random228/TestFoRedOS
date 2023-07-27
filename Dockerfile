# syntax=docker/dockerfile:1
FROM registry.red-soft.ru/ubi7/ubi-micro:latest
LABEL autor="Badalyan Tigran"

COPY nginx.conf /etc/nginx/

RUN sed -i '/user  nginx;/d' /etc/nginx/nginx.conf \
&& sed -i 's,/var/run/nginx.pid,/tmp/nginx.pid,' /etc/nginx/nginx.conf \
&& sed -i "/^http {/a \    proxy_temp_path /tmp/proxy_temp;\n    client_body_temp_path /tmp/client_temp;\n    fastcgi_temp_path /tmp/fastcgi_temp;\n    uwsgi_temp_path /tmp/uwsgi_temp;\n    scgi_temp_path /tmp/scgi_temp;\n" /etc/nginx/nginx.conf \
&& chown -R nginx:nginx /etc/nginx \
&& chmod -R g+w /etc/nginx \
&& rm -rf /var/log/nginx/ \
&& mkdir -p /var/log/nginx \
&& touch /var/log/nginx/error.log \
&& touch /var/log/nginx/access.log \
&& chown -R nginx:nginx /var/log/nginx \
&& touch /tmp/nginx.pid \
&& chown -R nginx:nginx /tmp/nginx.pid \
&& rm -f 15-local-resolvers.envsh && rm -f 30-tune-worker-processes.sh && rm -f 10-listen-on-ipv6-by-default.sh && rm -f 20-envsubst-on-templates.sh

RUN find / -name *nginx* -exec chgrp -R nginx {} \;
RUN find / -name *nginx* -exec chmod -R g=rwx {} \;

ENTRYPOINT ["nginx","-g","daemon off;"]
EXPOSE 8080

STOPSIGNAL SIGQUIT

USER nginx 
CMD ["nginx","-q","-c","/etc/nginx/nginx.conf"]
