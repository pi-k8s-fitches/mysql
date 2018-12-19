MACHINE=$(shell uname -m)
IMAGE=pi-k8s-fitches-mysql
VERSION=0.1
TAG="$(VERSION)-$(MACHINE)"
PORT=3306
ACCOUNT=gaf3
NAMESPACE=fitches
VARIABLES=-e MYSQL_ALLOW_EMPTY_PASSWORD='yes'

ifeq ($(MACHINE),armv7l)
BASE=arm32v7/debian:stretch-slim
else
BASE=debian:stretch-slim
endif

.PHONY: build shell start stop push create update delete create-dev update-dev delete-dev

build:
	docker build . --build-arg BASE=$(BASE) -t $(ACCOUNT)/$(IMAGE):$(TAG)

shell: build
	docker run -it $(VARIABLES) $(ACCOUNT)/$(IMAGE):$(TAG) sh

start:
	docker run --name $(IMAGE)-$(TAG) -d $(VARIABLES) --rm -p 127.0.0.1:$(PORT):$(PORT) -h $(IMAGE) $(ACCOUNT)/$(IMAGE):$(TAG) 

stop:
	docker rm -f $(IMAGE)-$(TAG)

push: build
	docker push $(ACCOUNT)/$(IMAGE):$(TAG)

create:
	kubectl --context=pi-k8s create -f k8s/pi-k8s.yaml

update:
	kubectl --context=pi-k8s replace -f k8s/pi-k8s.yaml

delete:
	kubectl --context=pi-k8s delete -f k8s/pi-k8s.yaml

create-dev:
	kubectl --context=minikube create -f k8s/minikube.yaml

update-dev:
	kubectl --context=minikube replace -f k8s/minikube.yaml

delete-dev:
	kubectl --context=minikube delete -f k8s/minikube.yaml
