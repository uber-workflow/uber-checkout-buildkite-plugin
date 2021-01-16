#!/bin/bash
# compiles go binary to different architectures

(
  env GOOS=darwin GOARCH=amd64 go build -o ./bin/uber-checkout-darwin-amd64 main.go
  env GOOS=linux GOARCH=amd64 go build -o ./bin/uber-checkout-linux-amd64 main.go
)
