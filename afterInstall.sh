#!/bin/bash
kubectl create namespace prometheus
helm install prometheus prometheus-community/kube-prometheus-stack --namespace=prometheus
kubectl label node k8s-node-1 node-role.kubernetes.io/worker=worker
