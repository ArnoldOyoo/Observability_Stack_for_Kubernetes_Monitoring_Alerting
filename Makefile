SHELL := /bin/bash

APP_IMAGE ?= your-docker-repo/custom-metrics-app:latest

.PHONY: terraform-init terraform-apply kubeconfig helm-install rules-apply app-deploy dashboards-import preflight deploy-stack verify-stack validate

terraform-init:
	cd terraform-cluster && terraform init

terraform-apply:
	cd terraform-cluster && terraform apply -var-file=terraform.tfvars

kubeconfig:
	aws eks update-kubeconfig --region $${AWS_REGION:-us-east-1} --name $${CLUSTER_NAME:-observability-eks}

helm-install:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
	helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
		--namespace monitoring --create-namespace \
		-f helm-values/kube-prometheus-stack-values.yaml

rules-apply:
	kubectl apply -f prometheus-config/prometheus-rules.yaml

app-deploy:
	sed 's|your-docker-repo/custom-metrics-app:latest|$(APP_IMAGE)|g' custom-metrics-app/k8s.yaml | kubectl apply -f -


dashboards-import:
	kubectl create configmap grafana-dashboard-cluster-resources \
		--from-file=grafana-dashboards/cluster-resources.json \
		-n monitoring \
		-o yaml --dry-run=client | kubectl label --local -f - grafana_dashboard=1 --overwrite -o yaml | kubectl apply -f -
	kubectl create configmap grafana-dashboard-custom-app \
		--from-file=grafana-dashboards/custom-app.json \
		-n monitoring \
		-o yaml --dry-run=client | kubectl label --local -f - grafana_dashboard=1 --overwrite -o yaml | kubectl apply -f -

preflight:
	./scripts/preflight.sh

deploy-stack:
	./scripts/deploy.sh

verify-stack:
	./scripts/verify.sh

validate:
	./scripts/validate.sh
