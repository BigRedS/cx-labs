TF_DIR=tf
ANSIBLE_DIR=ansible
KUBECONFIG=$(HOME)/.kube/k3s-ec2.yaml

export KUBECONFIG := $(KUBECONFIG)

up: vm cx otel-demo

vm:
	../common/tf-wrapper.sh $(TF_DIR) up k3s-ec2
	cd $(ANSIBLE_DIR) && ansible-playbook -i inventory.ini k3s.yaml

cx:
	../common/scripts/helm-install-cx-otel.sh

values:
	../common/scripts/helm-install-cx-otel.sh ./values.yaml

otel-demo:
	../common/scripts/helm-install-otel-demo.sh

destroy:
	../common/tf-wrapper.sh $(TF_DIR) down

plan:
	../common/tf-wrapper.sh $(TF_DIR) plan k3s-ec2

port-forward:
	@echo "UI will be available on http://localhost/8080"
	kubectl --kubeconfig $(KUBECONFIG) --namespace default port-forward svc/frontend-proxy "8080:8080"

k9s:
	k9s --kubeconfig $(KUBECONFIG)
