#!/bin/bash
kubectl create namespace prometheus
helm install prometheus prometheus-community/kube-prometheus-stack --namespace=prometheus
kubectl create namespace application
