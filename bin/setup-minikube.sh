#!/bin/bash

set -euo pipefail

MK_DRIVER="docker"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
BASE_DIR="$SCRIPT_DIR/.."

if [[ $(minikube status -o json | jq -r '.Host') != "Running" ]]; then
  minikube start --driver="$MK_DRIVER" --ports=80:80,443:443

  minikube addons enable dashboard
  minikube addons enable metrics-server
  minikube addons enable registry
  kubectl -n kube-system create secret tls traefikme \
    --key <(curl -o - -s https://traefik.me/privkey.pem) \
    --cert <(curl -o - -s https://traefik.me/fullchain.pem)
  echo kube-system/traefikme | minikube addons configure ingress
  minikube addons enable ingress
else
  echo "minikube is already running - skipping..."
fi
