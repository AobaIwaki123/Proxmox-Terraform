#!/bin/bash

# 環境一覧を表示するスクリプト

ENVS_DIR="envs"

if [ ! -d "$ENVS_DIR" ]; then
    echo "No environments directory found."
    exit 1
fi

echo "Available environments:"
echo ""

count=0
for env_dir in "$ENVS_DIR"/*/ ; do
    if [ -d "$env_dir" ]; then
        env_name=$(basename "$env_dir")
        
        # main.tfの内容からVMかContainerかを判定
        if grep -q "proxmox_vm_qemu" "$env_dir/main.tf" 2>/dev/null; then
            type="VM"
        elif grep -q "proxmox_lxc" "$env_dir/main.tf" 2>/dev/null; then
            type="Container"
        else
            type="Unknown"
        fi
        
        # Terraformの状態を確認
        if [ -f "$env_dir/.terraform.lock.hcl" ]; then
            status="initialized"
        else
            status="not initialized"
        fi
        
        echo "  - ${env_name} (${type}, ${status})"
        count=$((count + 1))
    fi
done

if [ $count -eq 0 ]; then
    echo "  No environments found."
    echo ""
    echo "Create an environment with:"
    echo "  make create-vm ENV=<name>"
    echo "  make create-ct ENV=<name>"
fi

echo ""
