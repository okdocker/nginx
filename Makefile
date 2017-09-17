DOCKER ?= $(shell which docker)
ROCKER ?= $(shell [ -x $(GOPATH)/bin/rocker ] && echo $(GOPATH)/bin/rocker || which rocker)
ROCKER_OPTIONS ?= --push
# see https://github.com/pagespeed/ngx_pagespeed/issues/1451
NGINX_VERSION ?= 1.13.3
NGINX_VARIANT ?= mainline
PAGESPEED_VERSION ?= 1.12.34.2
VERSION ?= latest
DOCKER_IMAGE ?= okdocker/nginx:$(VERSION)
ROCKER_VARIABLES ?= -var DockerImage=$(DOCKER_IMAGE) \
                    -var NginxVersion=$(NGINX_VERSION) \
                    -var NginxVariant=$(NGINX_VARIANT) \
                    -var PagespeedVersion=$(PAGESPEED_VERSION)

.PHONY = build push

build:
	$(ROCKER) build -f Rockerfile --attach $(ROCKER_OPTIONS) $(ROCKER_VARIABLES) .

shell: build
	$(DOCKER) run -it --rm $(DOCKER_IMAGE) bash
