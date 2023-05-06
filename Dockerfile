# stage1 as builder
FROM node:16.13.2-alpine as build

# copy the package.json to install dependencies
COPY package.json ./

# variaveis do backend
ENV BACKEND_URL=https://spotmusic-backend-4qt4toukxa-uc.a.run.app/
ENV PORT=8080

# Install the dependencies and make the folder
RUN npm install && mkdir /react-ui && mv ./node_modules ./react-ui

WORKDIR /react-ui

COPY . .

# Build the project and copy the files
RUN npm run build

FROM nginx:alpine

#!/bin/sh

COPY ./.nginx/nginx.conf /etc/nginx.conf

## Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy from the stahg 1
COPY --from=builder /react-ui/build /usr/share/nginx/html

EXPOSE 3000 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]
