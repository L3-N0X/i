# Build stage
FROM golang:1.21-alpine AS builder

# Set working directory
WORKDIR /app

# Copy go mod files
COPY go.mod ./

# Download dependencies
RUN go mod download

# Copy source code and required files
COPY i.go ./
COPY adjectives1.txt ./
COPY filetypes.json ./

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o i ./i.go

# Final stage
FROM alpine:latest

# Set working directory
WORKDIR /app

# Copy the binary and required files from builder
COPY --from=builder /app/i .
COPY --from=builder /app/adjectives1.txt .
COPY --from=builder /app/filetypes.json .

# Create directory for uploaded files
RUN mkdir -p /app/uploads

# Expose port 9005
EXPOSE 9005

# Set environment variables
ENV ROOT=/app/uploads/

# Run the application
CMD ["./i"]