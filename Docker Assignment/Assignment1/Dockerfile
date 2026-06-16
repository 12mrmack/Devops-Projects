FROM nginx:latest

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.sh /usr/share/nginx/html/index.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /usr/share/nginx/html/index.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
