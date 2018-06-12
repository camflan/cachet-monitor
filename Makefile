IMAGE_BASE_NAME := camflan/cachet-monitor
IMAGE_TAG := $(strip $(shell git describe --always))

GOLANG_VERSION := 1.9

ENV_FILE_PATH := .env
HOST_PORT := 8888

.PHONY := push test dev

build:
	@echo "Building..."
	go fmt
	docker build -t $(IMAGE_BASE_NAME):latest -t $(IMAGE_BASE_NAME):$(IMAGE_TAG) .
	@echo "done."

push:
	@echo "Pushing..."
	docker push $(IMAGE_BASE_NAME):latest
	docker push $(IMAGE_BASE_NAME):$(IMAGE_TAG)
	@echo "done."

run:
	@echo "Running..."
	docker run --rm -v $(shell pwd)/cachet-monitor.config.json:/config.json --env-file $(ENV_FILE_PATH) $(IMAGE_BASE_NAME):$(IMAGE_TAG) /app -c /config.json

test:
	@echo "Testing..."
	docker run --rm -v $(shell pwd):/go/src/github.com/camflan/cachet-monitor golang:$(GOLANG_VERSION) bash -c "cd /go/src/github.com/camflan/cachet-monitor; go get; go test ./..."

dev:
	@echo "Starting..."
	docker run --name cachet-monitor --rm --env-file $(ENV_FILE_PATH) -ti -v $(shell pwd):/go/src/github.com/camflan/cachet-monitor golang:$(GOLANG_VERSION) bash -c "cd /go/src/github.com/camflan/cachet-monitor; go get; /bin/bash"
