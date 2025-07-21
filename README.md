# GUESS_GAME no Docker

## Serviços utilizados
- Banco postgresql para persistência de dados.
- Backend em python utilizando Flask.
- Frontend com React.
- Nginx para proxy reverso e balanceamento de carga do backend.

## Volumes
- No serviço do postgres, possui um mount de volume para persistir os dados no ambiente local. Caso os containers sejam reiniciados, os dados não serão perdidos.

## Redes
- Todos os serviços estão na mesma rede personalizada chamada bridge_network, permitindo que os containers se comuniquem entre si.

## Balanceamento de carga
- O NGINX atua como balanceador de carga, encaminhando as requisições para diferentes containers do backend e ajudando a distribuir a carga de forma eficiente.

---
# Rodando localmente

## Requerimentos
- [Docker](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/linux/) 

## Como iniciar a aplicação
1. Rode o comando abaixo para iniciar os serviços com o docker compose criando 2 replicas para o backend:\
``
docker compose up --build --scale backend=2
``\
ou com o -d para iniciar os containers em background\
``
docker compose up -d --build --scale backend=2
``\
Esse comando irá iniciar os containers do postgresql, o backend e o frontend. Caso não tenha as imagens localmente, o docker irá buscar no registry e fazer o download.

2. No browser, acesse a URL http://localhost/
![alt text](image.png)
    
    2.1 Clique no Maker, crie uma palavra secreta e clique em Create Game. Copie o Game ID.
    ![alt text](image-1.png)

    2.2 Clique em Breaker, cole o Game ID e adivinhe a palavra secreta.
    ![alt text](image-2.png)

## Como desligar a aplicação
1. Rode o comando abaixo para desligar os serviços com o docker compose:\
``
docker compose down
``

## Atualizar a aplicação
1. Caso altere alguma configuração na aplicação, rode o comando abaixo:\
``
docker compose up --build
``\
Isso irá fazer com que o build da imagem rode novamente pegando as novas atualizações que foram alteradas.

---
# GUESS_GAME no Kubernetes
## Componentes k8s
- Deployment - para criar os pods da aplicação (frontend + backend) e do banco de dados.
- PV (Persistent Volume) - provisiona um storage local.
- PVC (Persistent Volume Claim) - solicitação do uso do storage pelo banco de dados.
- Service - expõe a aplicação localmente.
- HPA (Horizontal Pod Autoscaler) - configura uma regra para o backend escalar horizontalmente.
- Metrics Server - coleta métricas de recursos do kubelet, com essa API de métricas conseguimos utilizar o HPA. Esse componente sobe no namespace kube-system.
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
kubectl create -f kubernetes/secrets.yaml
``\
``
kubectl create -f kubernetes/volume.yaml
``\
``
kubectl create -f kubernetes/database.yaml
``\
``
kubectl create -f kubernetes/metrics-server/components.yaml
``\
``
kubectl create -f kubernetes/apps.yaml
``

2. Verifique se todos os pods estão com status running:\
``
kubectl get pods
``

3. Rode o comando para fazer o port-forward no service do frontend:\
``
kubectl port-forward service/frontend-svc 8080:80
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
kubectl create -f kubernetes/metrics-server/components.yaml
``