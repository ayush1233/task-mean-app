# ============================================
# Frontend Dockerfile - Multi-stage Angular Build
# ============================================

# ---------- Stage 1: Build Angular App ----------
FROM node:18-alpine AS build

WORKDIR /app

# Copy dependency manifests first (better layer caching)
COPY package*.json ./

# Install all dependencies (including devDependencies for build)
RUN npm install

# Copy remaining source code
COPY . .

# Build Angular app for production
RUN npm run build

# ---------- Stage 2: Serve with Nginx ----------
FROM nginx:alpine

# Remove default nginx static content
RUN rm -rf /usr/share/nginx/html/*

# Copy built Angular app from build stage
COPY --from=build /app/dist/angular-15-crud /usr/share/nginx/html

# Copy custom nginx config for SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
