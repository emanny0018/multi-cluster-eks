# Stage 1: Build the Go app
FROM golang:1.19-alpine AS builder
WORKDIR /app
COPY . .
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -o ericmanny

# Stage 2: Use distroless for the final image
FROM gcr.io/distroless/static-debian11
WORKDIR /app
COPY --from=builder /app/ericmanny /app/ericmanny
EXPOSE 8080
CMD ["/app/ericmanny"]

