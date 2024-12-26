#!/bin/bash

set -e

# Variables
ARGOCD_HOST="argocd.stockpnl.com"
APP_HOST="stockpnl.com"
HOSTED_ZONE_ID="Z022564630P941WV72XMM"
AWS_REGION="eu-north-1"

echo "Installing NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.0/deploy/static/provider/cloud/deploy.yaml

echo "Waiting for NGINX Ingress Controller to become ready..."
kubectl rollout status deployment/ingress-nginx-controller -n ingress-nginx

echo "Creating Ingress for ArgoCD..."
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-ingress
  namespace: argocd
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: ${ARGOCD_HOST}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: argocd-server
            port:
              number: 443
  tls:
  - hosts:
    - ${ARGOCD_HOST}
    secretName: argocd-tls
EOF

echo "Creating Ingress for the application..."
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  namespace: default
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: ${APP_HOST}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-service
            port:
              number: 80
EOF

echo "Waiting for Load Balancer DNS..."
LOAD_BALANCER_HOSTNAME=$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
if [ -z "$LOAD_BALANCER_HOSTNAME" ]; then
  echo "Error: Load Balancer hostname not available. Check the status of the NGINX Ingress Controller."
  exit 1
fi
echo "Load Balancer Hostname: $LOAD_BALANCER_HOSTNAME"

echo "Creating Route 53 DNS records..."
cat <<EOF > /tmp/route53-changes.json
{
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "${ARGOCD_HOST}",
        "Type": "CNAME",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "${LOAD_BALANCER_HOSTNAME}"
          }
        ]
      }
    },
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "${APP_HOST}",
        "Type": "A",
        "AliasTarget": {
          "HostedZoneId": "Z23TAZ6LKFMNIO", 
          "DNSName": "${LOAD_BALANCER_HOSTNAME}",
          "EvaluateTargetHealth": false
        }
      }
    }
  ]
}
EOF

aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch file:///tmp/route53-changes.json

echo "Setup complete!"
echo "Access ArgoCD at https://${ARGOCD_HOST}"
echo "Access the application at https://${APP_HOST}"
