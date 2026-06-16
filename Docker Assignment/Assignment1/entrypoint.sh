#!/bin/bash

while true
do
    /usr/share/nginx/html/index.sh > /usr/share/nginx/html/index.html
    sleep 60
done &
nginx -g "daemon off;"
