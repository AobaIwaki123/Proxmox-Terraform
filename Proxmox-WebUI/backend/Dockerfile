FROM golang:1.25-alpine AS dev

# Install curl for health checks
RUN apk add --no-cache curl

WORKDIR /app

# Copy go mod files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN go build -o main .

# Expose port
EXPOSE 8080
