# Creating Prometheus datasource on Grafana

export LB=$(kubectl -n monitoring get svc grafana -o json |jq .status.loadBalancer.ingress[0].hostname | sed 's/"//g')

echo $LB

curl "http://admin:root@${LB}/api/datasources" -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"Prometheus","type":"prometheus","url":"http://prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090","access":"proxy","isDefault":true}'
