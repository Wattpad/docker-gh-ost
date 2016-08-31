.PHONY: ghost build push

PREFIX=wattpad/gh-ost
GHOST_REVISION=904215e

GHOST_VERSION=ghost-$(GHOST_REVISION)
BUILD_VERSION=build-$(shell git rev-parse --short HEAD)
ALPINE_VERSION=alpine-$(shell grep '^FROM alpine' Dockerfile  | cut -d ':' -f 2)

ifndef TAG
	TAG := $(GHOST_VERSION)_$(ALPINE_VERSION)_$(BUILD_VERSION)
endif

ghost:
	mkdir -p build
	docker run --rm \
						 -v `pwd`/build.sh:/build.sh:ro \
						 -v `pwd`/build:/build \
						 -e REVISION=$(GHOST_REVISION) \
						 golang:1.6-alpine sh /build.sh

build: ghost
	docker build -t $(PREFIX):$(TAG) .

push: build
	docker push $(PREFIX):$(TAG)
