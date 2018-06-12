STATE="terraform.tfstate"
TERRAFORM_INSTALL_DIR="/usr/bin"
TERRAFORM_BIN_URL="https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip"
TERRAFORM_INVENTORY_URL="https://github.com/adammck/terraform-inventory/releases/download/v0.7-pre/terraform-inventory_v0.7-pre_linux_amd64.zip"
OST_DYNAMIC_URL="https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/openstack.py"
TRACE_LEVEL="DEBUG"

dependencies:
	curl $(TERRAFORM_BIN_URL) -o /tmp/terraform.zip && sudo unzip /tmp/terraform.zip -d $(TERRAFORM_INSTALL_DIR)/
	curl -sL -o terraform-inventory.zip $(TERRAFORM_INVENTORY_URL)
	unzip terraform-inventory.zip

env-build: export TF_LOG=$(TRACE_LEVEL)
	terraform init
	terraform plan
	terraform apply

env-destroy: export TF_LOG=$(TRACE_LEVEL)
	terraform destroy

ping-hosts:
	ansible -i ./terraform-inventory --ssh-extra-args="-o StrictHostKeyChecking=no" -u cloud-user -mping all