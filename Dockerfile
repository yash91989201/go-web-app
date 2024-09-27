# Use golang image to build the application
FROM golang:1.23 AS builder

WORKDIR /app

COPY go.mod  .
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Final image using scratch for minimal size
FROM scratch

# Copy the Go binary and static files from the builder image
COPY --from=builder /app/main /main
COPY --from=builder /app/static /static

# Set the working directory
WORKDIR /

# Expose port 8080
EXPOSE 8080

# Run the Go binary
CMD ["/main"]

