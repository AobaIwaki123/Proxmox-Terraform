#!/bin/bash

# プロバイダー設定ファイルを作成するスクリプト
# Usage: ./scripts/setup-provider.sh [ENV_NAME]

set -e

ENV_NAME=$1

# 環境名が指定されている場合は特定の環境に設定
if [ -n "$ENV_NAME" ]; then
    ENV_DIR="envs/${ENV_NAME}"
    
    if [ ! -d "$ENV_DIR" ]; then
        echo "Error: Environment '${ENV_NAME}' does not exist at ${ENV_DIR}"
        exit 1
    fi
    
    # main.tfの内容からVMかContainerかを判定
    if grep -q "proxmox_vm_qemu" "$ENV_DIR/main.tf" 2>/dev/null; then
        PROVIDER_EXAMPLE="modules/proxmox_vm/provider.tf.example"
    elif grep -q "proxmox_lxc" "$ENV_DIR/main.tf" 2>/dev/null; then
        PROVIDER_EXAMPLE="modules/proxmox_lxc/provider.tf.example"
    else
        echo "Error: Could not determine environment type"
        exit 1
    fi
    
    cp "$PROVIDER_EXAMPLE" "${ENV_DIR}/provider.tf"
    echo "✓ Provider configuration created at ${ENV_DIR}/provider.tf"
    echo "  Please edit this file with your Proxmox API credentials."
else
    # 環境名が指定されていない場合はモジュールレベルで設定（後方互換性）
    cp modules/proxmox_vm/provider.tf.example modules/proxmox_vm/provider.tf
    cp modules/proxmox_lxc/provider.tf.example modules/proxmox_lxc/provider.tf
    echo "✓ Provider configurations created:"
    echo "  - modules/proxmox_vm/provider.tf"
    echo "  - modules/proxmox_lxc/provider.tf"
    echo "  Please edit these files with your Proxmox API credentials."
fi
