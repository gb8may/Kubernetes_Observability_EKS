# Deploy monitoring environment on Kubernetes

# Creating Namespace and Secret
echo "Configuring namespace and other components.."
kubectl apply -f grafana-monitoring.yaml

# Deploy kube-state-metrics
kubectl apply -f ./kube-state-metrics/.

# Install Prometheus and Grafana via Helm
echo "Installing Prometheus.."
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install prometheus -n monitoring -f prometheus-values.yaml bitnami/kube-prometheus
cont=0
max=10
while [ "`kubectl -n monitoring get pods |grep prometheus-prometheus-kube-prometheus-prometheus-0 |grep '2/2' |grep Running 2>/dev/null`" = "" -a $cont -le $max ] ; do
    sleep 10s
    cont=`echo "$cont+1"|bc`
    echo -n '.'
done
if [ "`kubectl -n monitoring get pods |grep prometheus-prometheus-kube-prometheus-prometheus-0 |grep '2/2' |grep Running 2>/dev/null`" = "" ] ; then
    echo 'Something wrong with Prometheus! Exiting...'
    exit 1
fi

echo "Installing Grafana"
helm install grafana -n monitoring -f grafana-values.yaml bitnami/grafana
cont=0
max=10
while [ "`kubectl -n monitoring get pods |grep grafana |grep '1/1' |grep Running 2>/dev/null`" = "" -a $cont -le $max ] ; do
    sleep 10s
    cont=`echo "$cont+1"|bc`
    echo -n '.'
done
if [ "`kubectl -n monitoring get pods |grep grafana |grep '1/1' |grep Running 2>/dev/null`" = "" ] ; then
    echo 'Something wrong with Grafana! Exiting...'
    exit 1
fi

# Creating Configmap
kubectl apply -f grafana-cm.yaml

# Configuring Prometheus datasource on Grafana
echo "Configuring Prometheus Datasource and Grafana Dashboard...."

PW=$(echo "cm9vdA==" | base64 --decode)
export LB=$(kubectl -n monitoring get svc grafana -o json |jq .status.loadBalancer.ingress[0].hostname | sed 's/"//g')

cont=0
max=10
while [ "`curl -o - http://${LB} 2>/dev/null`" = "" -a $cont -le $max ] ; do
    sleep 10s
    cont=`echo "$cont+1"|bc`
    echo -n '.'
done

curl "http://admin:${PW}@${LB}/api/datasources" -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"Prometheus","type":"prometheus","url":"http://prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090","access":"proxy","isDefault":true}'

# Configuring Dashboard
curl -i -u admin:${PW} -H "Content-Type:application/json;charset=UTF-8" -X POST http://${LB}/api/dashboards/db -d @dashboards/dashboard.json

clear

echo "Your dashboard is UP at http://${LB}/d/inID2Jz7z"
