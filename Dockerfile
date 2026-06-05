# syntax=docker/dockerfile:1

# --- Build stage: Node 22 Alpine ---
FROM node:22-alpine AS build
WORKDIR /app

# Solo package.json: npm install fresco genera i binari nativi corretti per Linux
# (NON usiamo il package-lock.json, vedi regole Coolify)
COPY package.json ./
RUN npm install

COPY . .
RUN npm run build

# --- Serve stage: Nginx Alpine ---
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 4321
CMD ["nginx", "-g", "daemon off;"]
