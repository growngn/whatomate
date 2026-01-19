# Build frontend
FROM node:20-alpine AS frontend
WORKDIR /app
COPY frontend/package*.json ./
RUN npm install
COPY frontend .
RUN npm run build

# Build Go binary with embedded frontend
FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
COPY --from=frontend /app/dist ./frontend/dist
RUN go build -o whatomate ./cmd/whatomate

# Final runtime image
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/whatomate .
CMD ["./whatomate", "server", "-migrate"]