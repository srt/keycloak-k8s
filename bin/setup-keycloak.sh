#!/bin/bash

KC_VERSION=24.0.3

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
BASE_DIR="$SCRIPT_DIR/.."

kubectl apply -f "https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/$KC_VERSION/kubernetes/keycloaks.k8s.keycloak.org-v1.yml"
kubectl apply -f "https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/$KC_VERSION/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml"
kubectl apply -f "https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/$KC_VERSION/kubernetes/kubernetes.yml"

kubectl create secret generic keycloak-db-secret \
  --from-literal=username=testuser \
  --from-literal=password=testpassword

kubectl create secret tls traefikme \
  --key <(curl -o - -s https://traefik.me/privkey.pem) \
  --cert <(curl -o - -s https://traefik.me/fullchain.pem)

kubectl apply -f "$BASE_DIR/postgres.yaml"
kubectl apply -f "$BASE_DIR/keycloak.yaml"
