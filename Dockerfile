FROM node:18-alpine AS builder

WORKDIR /app

# Install dependencies
COPY frontend/package*.json ./
RUN npm ci --legacy-peer-deps

# Copy source and build
COPY frontend/ .
RUN npm run build

FROM node:18-alpine
WORKDIR /app

# Use a small static server to serve the build
RUN npm install -g serve
COPY --from=builder /app/build ./build

EXPOSE 3000
CMD ["serve", "-s", "build", "-l", "3000"]
