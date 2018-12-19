MACHINE=$(shell uname -m)
IMAGE=mysql
VERSION=5.7
PORT=3306
NAMESPACE=fitches
VARIABLES=-e MYSQL_ALLOW_EMPTY_PASSWORD='yes'
VOLUMES=-v ${PWD}/data:/var/lib/mysql

.PHONY: start stop create update delete create-dev update-dev delete-dev

start:
	docker run --name $(IMAGE)-$(VERSION) $(VARIABLES) $(VOLUMES) -d --rm -p 127.0.0.1:$(PORT):$(PORT) -h $(IMAGE) $(IMAGE):$(VERSION) 

stop:
	docker rm -f $(IMAGE)-$(VERSION)

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
