#!/bin/bash
# buildkite doesn't have golang installed, so we build inside a slim docker image

readonly dir="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

if [ "$BUILDKITE" = true ]; then
  GOOS=linux
  GOARCH=amd64
else
  GOOS=$(go env GOOS)
  GOARCH=$(go env GOARCH)
fi

# build in docker image
docker run --rm \
  -v "$dir/src":/usr/src/_cli \
  -w /usr/src/_cli \
  -e GOOS="$GOOS" \
  -e GOARCH="$GOARCH" \
  golang:1.15-alpine \
  go build ./...

mv "${dir}/src/_cli" ./cli