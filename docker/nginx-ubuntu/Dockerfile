FROM ubuntu
WORKDIR /tmp
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y nginx 
COPY nginx_default_config /etc/nginx/sites-available/default
EXPOSE 80
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
