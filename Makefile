all: create wait

create:
	kubectl create -f kubernetes/namespace.yaml
	kubectl create -f kubernetes/secrets.yaml
	kubectl create -f kubernetes/volume.yaml
	kubectl create -f kubernetes/database.yaml

wait:
	@echo "Waiting for database..."
	sleep 3
	kubectl create -f kubernetes/apps.yaml

delete:		
	kubectl delete -f kubernetes/apps.yaml
	kubectl delete -f kubernetes/database.yaml
	kubectl delete -f kubernetes/volume.yaml
	kubectl delete -f kubernetes/secrets.yaml
	kubectl delete -f kubernetes/namespace.yaml