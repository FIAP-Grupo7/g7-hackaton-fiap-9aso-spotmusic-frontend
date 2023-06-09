# stage1 as builder
FROM node:16.13.2-alpine as build

# copy the package.json to install dependencies
COPY package.json ./

# Install the dependencies and make the folder
RUN npm install && mkdir /react-ui && mv ./node_modules ./react-ui

WORKDIR /react-ui

COPY . .

# Build the project and copy the files
RUN npm run build

FROM nginx:alpine

#!/bin/sh

COPY ./nginx.conf /etc/nginx/conf.d/default.conf

## Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy from the stahg 1
COPY --from=build /react-ui/build /usr/share/nginx/html

ENTRYPOINT ["nginx", "-g", "daemon off;"]
