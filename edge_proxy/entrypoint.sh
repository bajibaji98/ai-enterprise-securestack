#!/bin/sh
set -e
mkdir -p /etc/nginx/certs
if [ ! -f /etc/nginx/certs/server.crt ]; then
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=US/ST=NA/L=Local/O=SecureStack/OU=Dev/CN=localhost" -keyout /etc/nginx/certs/server.key -out /etc/nginx/certs/server.crt
fi
exec nginx -g 'daemon off;'
