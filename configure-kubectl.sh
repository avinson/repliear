#!/bin/bash

KUBERNETES_SERVER=https://kubernetes.default.svc
KUBERNETES_CA_CERTIFICATE=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
KUBERNETES_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)

kubectl config set-cluster default-cluster --server=${KUBERNETES_SERVER} --certificate-authority=${KUBERNETES_CA_CERTIFICATE} --embed-certs=true
kubectl config set-credentials default-admin --token=${KUBERNETES_TOKEN}
kubectl config set-context default-system --cluster=default-cluster --user=default-admin
kubectl config use-context default-system
