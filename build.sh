#!/bin/bash
# compiles go binary to different architectures

(
  cd src
  env GOOS=darwin GOARCH=amd64 go build -o ../bin/uber-checkout-darwin-amd64 main.go
  env GOOS=linux GOARCH=amd64 go build -o ../bin/uber-checkout-linux-amd64 main.go
)

# readonly dir="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

# if [ "$BUILDKITE" = true ]; then
#   GOOS=linux
#   GOARCH=amd64
# else
#   GOOS=$(go env GOOS)
#   GOARCH=$(go env GOARCH)
# fi

# # build in docker image
# docker run --rm \
#   -v "$dir/src":/usr/src \
#   -w /usr/src \
#   -e GOOS="$GOOS" \
#   -e GOARCH="$GOARCH" \
#   golang:1.15-alpine \
#   go build ./main.go

# mv "${dir}/src/main" ./cli