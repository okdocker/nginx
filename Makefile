DOCKER ?= $(shell which docker)
ROCKER ?= $(shell [ -x $(GOPATH)/bin/rocker ] && echo $(GOPATH)/bin/rocker || which rocker)
ROCKER_OPTIONS ?=
# see https://github.com/pagespeed/ngx_pagespeed/issues/1451
NGINX_VERSION ?= 1.13.9
NGINX_VARIANT ?= mainline
PAGESPEED_VERSION ?= 1.13.35.2
PSOL_VERSION ?= 1.13.35.2
VERSION ?= latest
DOCKER_IMAGE ?= okdocker/nginx
DOCKER_TAG ?= $(DOCKER_IMAGE):$(VERSION)
DOCKER_RUN_COMMAND ?=
DOCKER_RUN_OPTIONS ?=
ROCKER_VARIABLES ?= -var DockerImage=$(DOCKER_TAG) \
                    -var NginxVersion=$(NGINX_VERSION) \
                    -var NginxVariant=$(NGINX_VARIANT) \
                    -var PagespeedVersion=$(PAGESPEED_VERSION) \
                    -var PsolVersion=$(PSOL_VERSION)

.PHONY = build push

build:
	$(ROCKER) build -f Rockerfile --attach $(ROCKER_OPTIONS) $(ROCKER_VARIABLES) .

docker-run: build
	$(DOCKER) run -it $(DOCKER_RUN_OPTIONS) --rm $(DOCKER_TAG) $(DOCKER_RUN_COMMAND)

run:
	DOCKER_RUN_OPTIONS=-P $(MAKE) docker-run

shell:
	DOCKER_RUN_COMMAND=/bin/bash $(MAKE) docker-run

