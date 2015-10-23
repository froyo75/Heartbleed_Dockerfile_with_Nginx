#!/bin/bash
set -e

echo ">> Generating self signed cert..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /usr/local/nginx/nginx.key -out /usr/local/nginx/nginx.crt

exec "$@"