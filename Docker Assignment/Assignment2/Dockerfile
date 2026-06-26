FROM ubuntu:latest

LABEL maintainer="Maqbool Alam"

RUN apt-get update && \
    apt-get install -y nodejs npm

# RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN npm install -g http-server

WORKDIR /usr/apps/docker-app

COPY index.html .

EXPOSE 8080

CMD ["http-server", "-p", "8080"]
