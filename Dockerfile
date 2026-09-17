FROM nginx:1.29-alpine

COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template

EXPOSE 8080
