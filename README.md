
# Kubernetes EKS monitoring with Prometheus and Grafana via Helm

Pre-requisites:
- eksctl
- kubectl
- helm

Helm version: 3.1.2
```
export DESIRED_VERSION=v3.1.2
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.shh
```

Cluster deploy
```
eksctl create cluster -f eks_cluster.yaml
```

Monitoring deploy
```
./monitoring-deploy.sh
```

Deploy Application
```
kubectl create ns selenium
kubectl -n selenium apply -f ./application/.
```
