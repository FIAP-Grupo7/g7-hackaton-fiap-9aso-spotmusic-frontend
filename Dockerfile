# build
FROM node:16.13.2-alpine as build
WORKDIR /app
COPY package.json ./

# variaveis do backend
ENV BACKEND_URL=https://spotmusic-backend-4qt4toukxa-uc.a.run.app/
ENV PORT=8080

RUN npm install
COPY . ./
RUN npm run build

# release
FROM nginx:1.21.5-alpine as release
COPY --from=build /app/build /usr/share/nginx/html/
CMD ["nginx", "-g", "daemon off;"]
