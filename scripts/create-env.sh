#!/bin/bash

# 環境を作成するスクリプト
# Usage: ./scripts/create-env.sh <vm|ct> <ENV_NAME>

set -e

TYPE=$1
ENV_NAME=$2

if [ -z "$TYPE" ] || [ -z "$ENV_NAME" ]; then
    echo "Error: TYPE and ENV_NAME are required."
    echo "Usage: $0 <vm|ct> <ENV_NAME>"
    exit 1
fi

if [ "$TYPE" != "vm" ] && [ "$TYPE" != "ct" ]; then
    echo "Error: TYPE must be 'vm' or 'ct'"
    exit 1
fi

TARGET_DIR="envs/${ENV_NAME}"

if [ -d "$TARGET_DIR" ]; then
    echo "Error: Environment '${ENV_NAME}' already exists at ${TARGET_DIR}"
    exit 1
fi

if [ "$TYPE" == "vm" ]; then
    cp -r template/vm "$TARGET_DIR"
    echo "VM environment created at ${TARGET_DIR}"
else
    cp -r template/container "$TARGET_DIR"
    echo "Container environment created at ${TARGET_DIR}"
fi

# テンプレートから不要なファイルを削除
rm -f "${TARGET_DIR}/Taskfile.yml" 2>/dev/null || true
rm -f "${TARGET_DIR}/Makefile" 2>/dev/null || true

echo "✓ Environment '${ENV_NAME}' created successfully"
echo "  Next steps:"
echo "  1. Edit ${TARGET_DIR}/terraform.tfvars"
echo "  2. Run: make init ENV=${ENV_NAME}"
echo "  3. Run: make apply ENV=${ENV_NAME}"
