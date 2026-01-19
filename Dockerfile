# Build stage with Go and Node.js
FROM golang:1.24-bullseye AS builder

# Install Node.js and npm
RUN apt-get update && apt-get install -y nodejs npm

WORKDIR /app

# Copy Go modules first for better caching
COPY go.mod go.sum ./
RUN go mod download

# Copy everything
COPY . .

# Build frontend and embed in Go binary
RUN make build-prod

# Build Go binary
RUN go build -o /bin/whatomate ./cmd/whatomate

# Runtime stage
FROM debian:bullseye-slim

# Copy binary from builder
COPY --from=builder /bin/whatomate /bin/whatomate

# Expose port
EXPOSE 8080

# Run with migrations
CMD ["/bin/whatomate", "server", "-migrate"]