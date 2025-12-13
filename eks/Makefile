TF_DIR=tf
KUBECONFIG=$(HOME)/.kube/eks.yaml

export KUBECONFIG := $(KUBECONFIG)

up: cluster cx otel-demo

cluster:
	../common/tf-wrapper.sh $(TF_DIR) up eks

cx:
	../common/scripts/helm-install-cx-otel.sh

values:
	../common/scripts/helm-install-cx-otel.sh ./values.yaml

otel-demo:
	export KUBECONFIG=$(KUBECONFIG)
	../common/scripts/helm-install-otel-demo.sh

destroy:
	../common/tf-wrapper.sh $(TF_DIR) down

plan:
	../common/tf-wrapper.sh $(TF_DIR) plan eks

port-forward:
	@echo "UI will be available on http://localhost/8080"
	kubectl --kubeconfig $(KUBECONFIG) --namespace default port-forward svc/frontend-proxy "8080:8080"

k9s:
	k9s --kubeconfig $(KUBECONFIG)

workspaces:
	../common/tf-wrapper.sh $(TF_DIR) workspaces eks
