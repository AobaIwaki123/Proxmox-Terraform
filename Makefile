.PHONY: help list create-vm create-ct init plan apply destroy clean validate fmt setup-provider delete-all

# デフォルトターゲット
help:
	@echo "Proxmox Terraform Management"
	@echo ""
	@echo "環境管理コマンド:"
	@echo "  make list                    - 作成済み環境の一覧を表示"
	@echo "  make create-vm ENV=<name>    - VM環境を作成"
	@echo "  make create-ct ENV=<name>    - Container環境を作成"
	@echo "  make delete-all              - 全ての環境を削除（注意！）"
	@echo ""
	@echo "Terraform操作コマンド (ENV=<name>が必須):"
	@echo "  make init ENV=<name>         - Terraformを初期化"
	@echo "  make plan ENV=<name>         - 実行計画を表示"
	@echo "  make apply ENV=<name>        - リソースを作成/更新"
	@echo "  make destroy ENV=<name>      - リソースを削除"
	@echo "  make clean ENV=<name>        - Terraform状態ファイルを削除"
	@echo "  make validate ENV=<name>     - 設定ファイルを検証"
	@echo "  make fmt ENV=<name>          - 設定ファイルをフォーマット"
	@echo ""
	@echo "セットアップコマンド:"
	@echo "  make setup-provider          - プロバイダー設定ファイルを作成（モジュールレベル）"
	@echo "  make setup-provider ENV=<name> - 特定環境のプロバイダー設定ファイルを作成"
	@echo ""
	@echo "例:"
	@echo "  make create-vm ENV=web-server"
	@echo "  make init ENV=web-server"
	@echo "  make apply ENV=web-server"

list:
	@./scripts/list-envs.sh

create-vm:
ifndef ENV
	@echo "Error: ENV is required. Usage: make create-vm ENV=<name>"
	@exit 1
endif
	@./scripts/create-env.sh vm $(ENV)

create-ct:
ifndef ENV
	@echo "Error: ENV is required. Usage: make create-ct ENV=<name>"
	@exit 1
endif
	@./scripts/create-env.sh ct $(ENV)

init:
ifndef ENV
	@echo "Error: ENV is required. Usage: make init ENV=<name>"
	@exit 1
endif
	@./scripts/terraform-wrapper.sh $(ENV) init

plan:
ifndef ENV
	@echo "Error: ENV is required. Usage: make plan ENV=<name>"
	@exit 1
endif
	@./scripts/terraform-wrapper.sh $(ENV) plan

apply:
ifndef ENV
	@echo "Error: ENV is required. Usage: make apply ENV=<name>"
	@exit 1
endif
	@./scripts/terraform-wrapper.sh $(ENV) apply

destroy:
ifndef ENV
	@echo "Error: ENV is required. Usage: make destroy ENV=<name>"
	@exit 1
endif
	@./scripts/terraform-wrapper.sh $(ENV) destroy

clean:
ifndef ENV
	@echo "Error: ENV is required. Usage: make clean ENV=<name>"
	@exit 1
endif
	@./scripts/terraform-wrapper.sh $(ENV) clean

validate:
ifndef ENV
	@echo "Error: ENV is required. Usage: make validate ENV=<name>"
	@exit 1
endif
	@./scripts/terraform-wrapper.sh $(ENV) validate

fmt:
ifndef ENV
	@echo "Error: ENV is required. Usage: make fmt ENV=<name>"
	@exit 1
endif
	@./scripts/terraform-wrapper.sh $(ENV) fmt

setup-provider:
ifdef ENV
	@./scripts/setup-provider.sh $(ENV)
else
	@./scripts/setup-provider.sh
endif

delete-all:
	@echo "WARNING: This will delete ALL environments!"
	@echo "Press Ctrl+C to cancel, or Enter to continue..."
	@read dummy
	@rm -rf envs/*
	@echo "✓ All environments deleted"
