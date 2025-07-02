# GUESS_GAME no Kubernetes

## Serviços utilizados
- Banco postgresql para persistência de dados.
- Backend em python utilizando Flask.
- Frontend com React.
- Nginx para proxy reverso e balanceamento de carga do backend.


## Componentes k8s
- Namespace
- Deployment
- PV (Persistent Volume)
- PVC (Persistent Volume Claim)
- Service
- HPA (Horizontal Pod Autoscaler)

---
# Rodando localmente

## Requerimentos
1. Ambiente kubernetes local
    - [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
    - [minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download)

## Como iniciar a aplicação
1. Rode o comando abaixo para criar os recursos no kubernetes:\
``
make
``\
ou crie cada componente separadamente:\
``
kubectl create -f kubernetes/namespace.yaml
``\
``
kubectl create -f kubernetes/secrets.yaml
``\
``
kubectl create -f kubernetes/volume.yaml
``\
``
kubectl create -f kubernetes/database.yaml
``\
``
kubectl create -f kubernetes/apps.yaml
``

2. Verifique se todos os pods estão com status running:\
``
kubectl get pods -n app
``\
``
kubectl get pods -n database
``

3. Rode o comando para fazer o port-forward no service do frontend:\
``
kubectl port-forward service/frontend-svc 8080:80 -n app
``

4. Acesse [**localhost:8080**](http://localhost:8080) pelo browser para acessar o jogo.

## Como desligar a aplicação
1. Rode o comando abaixo para deletar os recursos no kubernetes:\
``
make delete
``\
ou delete cada componente separadamente:\
``
kubectl delete -f kubernetes/apps.yaml
``\
``
kubectl delete -f kubernetes/database.yaml
``\
``
kubectl delete -f kubernetes/volume.yaml
``\
``
kubectl delete -f kubernetes/secrets.yaml
``\
``
kubectl delete -f kubernetes/namespace.yaml
``
