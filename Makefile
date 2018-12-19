MACHINE=$(shell uname -m)
IMAGE=pi-k8s-fitches-mysql
VERSION=0.1
TAG="$(VERSION)-$(MACHINE)"
PORT=3306
ACCOUNT=gaf3
NAMESPACE=fitches
VARIABLES=-e MYSQL_ALLOW_EMPTY_PASSWORD='yes'
VOLUMES=-v ${PWD}/data:/var/lib/mysql

ifeq ($(MACHINE),armv7l)
BASE=resin/rpi-raspbian:stretch
else
BASE=debian:stretch
endif

.PHONY: build shell start stop push create update delete create-dev update-dev delete-dev

build:
	docker build . --build-arg BASE=$(BASE) -t $(ACCOUNT)/$(IMAGE):$(TAG)

shell:
	docker run -it $(VARIABLES) $(VOLUMES) $(ACCOUNT)/$(IMAGE):$(TAG) sh

start:
	docker run --name $(IMAGE)-$(TAG) $(VARIABLES) $(VOLUMES) --rm -p 127.0.0.1:$(PORT):$(PORT) -h $(IMAGE) $(ACCOUNT)/$(IMAGE):$(TAG) 

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
