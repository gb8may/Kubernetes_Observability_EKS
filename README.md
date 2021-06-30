
# Kubernetes EKS monitoring with Prometheus and Grafana via Helm

![AWS](https://img.shields.io/badge/-AWS-232F3E?&logo=amazon%20aws&logoColor=FFFFFF) ![Kubernetes](https://img.shields.io/badge/-Kubernetes-326CE5?&logo=kubernetes&logoColor=FFFFFF) ![Grafana](https://img.shields.io/badge/-Grafana-F46800?&logo=grafana&logoColor=FFFFFF) ![Prometheus](https://img.shields.io/badge/-Prometheus-E6522C?&logo=prometheus&logoColor=FFFFFF) ![Helm](https://img.shields.io/badge/-Helm-0F1689?&logo=helm&logoColor=FFFFFF)

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

</h>

There's a directory called Application and Dashboards; If you need to monitoring by labels, just deploy application via kubectl and apply application dashboard.
```
export test_number=test_01
cat dashboards/application-dashboard-template.json | sed "s/{test_number}/${test_number}/g" > application-dashboard.json
```
