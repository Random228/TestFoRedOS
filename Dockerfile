# syntax=docker/dockerfile:1
FROM registry.red-soft.ru/ubi7/ubi:latest AS builder
WORKDIR /opt/app/nginx
COPY --from=registry.red-soft.ru/ubi7/ubi-micro:latest ./ .
COPY nginx/* ./ \
instapp.bash ./
RUN ["dnf","install","cpio","-y"]
RUN ["bash","./instapp.bash"]

FROM registry.red-soft.ru/ubi7/ubi-micro:latest
LABEL autor="Badalyan Tigran"
COPY --from=builder /opt/app/nginx/ ./
RUN microdnf install nginx-1.18.0-1.el7 -y
RUN echo "nginx:x:10:0:nginx:/bin/bash" >> /etc/passwd
USER nginx
CMD ["echo","hello"]