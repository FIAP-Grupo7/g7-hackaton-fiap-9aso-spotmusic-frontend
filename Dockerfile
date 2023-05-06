# variaveis do backend
ENV BACKEND_URL 34.27.173.211

# build
FROM node:16.13.2-alpine as build
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . ./
RUN npm run build

# release
FROM nginx:1.21.5-alpine as release
COPY --from=build /app/build /usr/share/nginx/html/
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
