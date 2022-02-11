
FROM nginx:alpine
COPY static /usr/share/nginx/html
LABEL maintainer = "mooldocker@docker.com"
