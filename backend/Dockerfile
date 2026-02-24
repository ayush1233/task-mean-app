# ============================================
# Backend Dockerfile - Node.js + Express API
# ============================================

FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy dependency manifests first (better layer caching)
COPY package*.json ./

# Install production dependencies
RUN npm install --omit=dev

# Copy remaining backend source code
COPY . .

# Expose backend port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/ || exit 1

# Start the application
CMD ["npm", "start"]
