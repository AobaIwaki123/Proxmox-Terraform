# Proxmox Terraform

Proxmox 上の VM を Terraform で管理します。VM は `inventory/terraform.tfvars` の一覧に定義します。
共通設定と VM ごとの設定については [inventory/README.md](inventory/README.md) を参照してください。

## VM の操作

1. `task create-provider` で不足している provider 設定を作り、`inventory/provider.tf` に認証情報を設定する。
2. `inventory/terraform.tfvars.example` を `inventory/terraform.tfvars` にコピーし、VM の一覧を編集する。
3. `inventory/` で `terraform init` と `terraform plan` を実行する。
4. plan を確認し、意図した差分だけである場合に `terraform apply` を実行する。

既存 VM を別の state から移行する場合、一覧を追加するだけでは既存 VM を認識しません。
事前に state の対応付けと plan を確認してください。provider の認証情報、state、および
実際の tfvars はコミットしません。

既存 LXC テンプレートは当面残しています。

## Backup

Terraform の inventory、state、実環境設定の暗号化バックアップと復元手順は
[backup/README.md](backup/README.md) を参照してください。

## 参考

- [Telmate Proxmox provider](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs)
- [Terraform の state 管理](https://developer.hashicorp.com/terraform/language/state)
