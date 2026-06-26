FROM node:16-bullseye AS builder

MAINTAINER Opstree Solutions

COPY . /app
WORKDIR /app/
RUN apt-get update -y && apt-get install git -y
RUN npm install
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
