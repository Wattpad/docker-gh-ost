#! /bin/sh

log () {
  echo 1>&2 "$*"
}

if [ -z "$REVISION" ]; then
  log "REVISION environment variable must be set."
  exit 1
fi

VERSION="git-${REVISION}"
BINARY_FILE=/build/gh-ost
SOURCE_TARBALL_URL="https://github.com/github/gh-ost/archive/${REVISION}.tar.gz"
SOURCE_PATH="/go/src/github.com/github/gh-ost"

if [ -f "$BINARY_FILE" ]; then
  rm -f "$BINARY_FILE"
fi &&

log "Installing dependencies..." &&
apk --no-cache add tar curl &&

log "Downloading and extracting source... [SOURCE_TARBALL_URL: $SOURCE_TARBALL_URL]"
mkdir -p "${SOURCE_PATH}" &&
curl -L "$SOURCE_TARBALL_URL" | tar --strip-components=1 --directory="${SOURCE_PATH}" -xzv &&

log "Building gh-ost... [BINARY_FILE: ${BINARY_FILE}]"
cd "${SOURCE_PATH}" &&
CGO_ENABLED=0 exec go build \
    -v \
    -ldflags "-w -X main.AppVersion=${VERSION}" \
    -o ${BINARY_FILE} \
    go/cmd/gh-ost/main.go
