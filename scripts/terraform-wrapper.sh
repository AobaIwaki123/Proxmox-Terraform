#!/bin/bash

# Terraform操作のラッパースクリプト
# Usage: ./scripts/terraform-wrapper.sh <ENV_NAME> <COMMAND>

set -e

ENV_NAME=$1
COMMAND=$2

if [ -z "$ENV_NAME" ] || [ -z "$COMMAND" ]; then
    echo "Error: ENV_NAME and COMMAND are required."
    echo "Usage: $0 <ENV_NAME> <COMMAND>"
    exit 1
fi

ENV_DIR="envs/${ENV_NAME}"

if [ ! -d "$ENV_DIR" ]; then
    echo "Error: Environment '${ENV_NAME}' does not exist at ${ENV_DIR}"
    exit 1
fi

cd "$ENV_DIR"

case "$COMMAND" in
    init)
        echo "Initializing Terraform for environment '${ENV_NAME}'..."
        terraform init
        ;;
    plan)
        echo "Planning Terraform for environment '${ENV_NAME}'..."
        terraform plan -var-file=terraform.tfvars
        ;;
    apply)
        echo "Applying Terraform for environment '${ENV_NAME}'..."
        terraform apply -var-file=terraform.tfvars -auto-approve
        ;;
    destroy)
        echo "Destroying Terraform for environment '${ENV_NAME}'..."
        terraform destroy -var-file=terraform.tfvars -auto-approve
        ;;
    clean)
        echo "Cleaning Terraform state for environment '${ENV_NAME}'..."
        rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup
        ;;
    validate)
        echo "Validating Terraform for environment '${ENV_NAME}'..."
        terraform validate
        ;;
    fmt)
        echo "Formatting Terraform files for environment '${ENV_NAME}'..."
        terraform fmt
        ;;
    *)
        echo "Error: Unknown command '$COMMAND'"
        echo "Available commands: init, plan, apply, destroy, clean, validate, fmt"
        exit 1
        ;;
esac

echo "✓ Command '${COMMAND}' completed successfully for environment '${ENV_NAME}'"
