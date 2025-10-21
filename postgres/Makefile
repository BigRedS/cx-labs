TF_DIR=tf
ANSIBLE_DIR=ansible
KUBECONFIG=$(HOME)/.kube/postgres.yaml

export KUBECONFIG := $(KUBECONFIG)

up: vm cx postgres

vm:
	../common/tf-wrapper.sh $(TF_DIR) up postgres
	cd $(ANSIBLE_DIR) && ansible-playbook -i inventory.ini k3s.yaml

cx:
	../common/scripts/helm-install-cx-otel.sh

values:
	../common/scripts/helm-install-cx-otel.sh ./values.yaml

postgres:
	./install-tracey-reloaded.sh

destroy:
	../common/tf-wrapper.sh $(TF_DIR) down

plan:
	../common/tf-wrapper.sh $(TF_DIR) plan postgres

port-forward:
	@echo "UI will be available on http://localhost/8080"
	kubectl --kubeconfig $(KUBECONFIG) --namespace default port-forward svc/frontend-proxy "8080:8080"

k9s:
	k9s --kubeconfig $(KUBECONFIG)
