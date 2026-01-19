# Build stage with Go and Node.js
FROM golang:1.24-bullseye AS builder

# Install Node.js 20 (NOT Debian nodejs)
RUN apt-get update && apt-get install -y ca-certificates curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

RUN node -v && npm -v

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

# Install CA certificates
RUN apt-get update && \
    apt-get install -y ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy binary from builder
COPY --from=builder /bin/whatomate /bin/whatomate

# Expose port
EXPOSE 8080

# Run with migrations
CMD ["/bin/whatomate", "server", "-migrate"]