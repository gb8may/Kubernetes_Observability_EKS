# Deploy monitoring environment on Kubernetes

# Creating Namespace and Secret
kubectl apply -f grafana-monitoring.yaml

# Deploy kube-state-metrics
kubectl apply -f ./kube-state-metrics/.

# Install Prometheus and Grafana via Helm
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install prometheus -n monitoring -f prometheus-values.yaml bitnami/kube-prometheus
helm install grafana -n monitoring -f grafana-values.yaml bitnami/grafana

# Creating Configmap
kubectl apply -f grafana-cm.yaml

# Configuring Prometheus datasource on Grafana
echo "Configuring Prometheus Datasource and Grafana Dashboard...."
sleep 180 #Wait for Granafa become available

export LB=$(kubectl -n monitoring get svc grafana -o json |jq .status.loadBalancer.ingress[0].hostname | sed 's/"//g')

curl "http://admin:root@${LB}/api/datasources" -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"Prometheus","type":"prometheus","url":"http://prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090","access":"proxy","isDefault":true}'

# Configuring Dashboard
PW=$(echo "cm9vdA==" | base64 --decode)

curl -i -u admin:${PW} -H "Content-Type:application/json;charset=UTF-8" -X POST http://${LB}/api/dashboards/db -d @dashboard.json 

echo ""
echo "Your dashboard is UP at http://${LB}/d/7w4JC6R7z/load-test-test-01"
