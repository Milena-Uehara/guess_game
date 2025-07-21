#!/bin/bash
envsubst '$SERVER_ENDPOINT' < /etc/nginx/conf.d/nginx.conf.template > /etc/nginx/conf.d/default.conf
nginx -g 'daemon off;'