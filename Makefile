all: container

PREFIX = mephux
IMAGE = docker-golang
TAG = latest
FLAGS =

container:
	docker build -t $(PREFIX)/$(IMAGE):$(TAG) .

push: container
	docker push $(PREFIX)/$(IMAGE):$(TAG)

.PHONY: all container push
