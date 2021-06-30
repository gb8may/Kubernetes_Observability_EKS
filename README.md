
# Kubernetes EKS monitoring with Prometheus and Grafana via Helm

![EKS_Graf_Prom](https://user-images.githubusercontent.com/35708820/123995280-268f8e80-d99c-11eb-8b86-d636275f897d.png)

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

Deploy Application
```
kubectl create ns selenium
kubectl -n selenium apply -f ./application/.
```

Monitoring deploy
```
./monitoring-deploy.sh
```

There's a directory called Application and Dashboards; If you need to monitoring by labels, just deploy application via kubectl and apply application dashboard.
```
export test_number=test_01
cat dashboards/application-dashboard-template.json | sed "s/{test_number}/${test_number}/g" > application-dashboard.json
```
