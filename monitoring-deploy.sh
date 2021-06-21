kubectl apply -f grafana-monitoring.yaml
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install prometheus bitnami/kube-prometheus -n monitoring
helm install grafana -n monitoring -f grafana-values.yaml bitnami/grafana
kubectl apply -f grafana-cm.yaml
