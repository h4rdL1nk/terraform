STATE="terraform.tfstate"
TERRAFORM_INSTALL_DIR="/usr/bin"
TERRAFORM_BIN_URL="https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip"

install:
	curl $(TERRAFORM_BIN_URL) -o /tmp/terraform.zip && sudo unzip /tmp/terraform.zip -d $(TERRAFORM_INSTALL_DIR)/

env-build:
	terraform init
	terraform plan
	terraform apply

env-destroy:
	terraform destroy