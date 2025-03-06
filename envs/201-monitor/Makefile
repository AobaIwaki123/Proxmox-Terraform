tf-clean-init: tf-clean tf-init

tf-clean:
	rm -rf .terraform
	rm .terraform.lock.hcl
	rm terraform.tfstate
	rm terraform.tfstate.backup

tf-init:
	terraform init
	
tf-apply:
	terraform apply -var-file terraform.tfvars -auto-approve

tf-destroy:
	terraform destroy -var-file terraform.tfvars -auto-approve
