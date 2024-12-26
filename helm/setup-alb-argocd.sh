#!/bin/bash

CLUSTER_NAME="eks"
REGION="eu-north-1"

aws eks update-kubeconfig --region $REGION --name $CLUSTER_NAME

# deploy the ingress-nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.0/deploy/static/provider/cloud/deploy.yaml

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# enable ssl passthrough for ingress nginx
kubectl patch deployment ingress-nginx-controller -n ingress-nginx --type='json' -p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--enable-ssl-passthrough"}]'
