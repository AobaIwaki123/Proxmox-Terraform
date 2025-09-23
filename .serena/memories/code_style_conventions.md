# コーディング規約とスタイル

## Terraformコーディング規約

### ファイル命名
- `main.tf`: リソース定義
- `variables.tf`: 変数定義（注意: プロジェクト固有で`varialbles.tf`と表記）
- `outputs.tf`: 出力定義
- `provider.tf`: プロバイダー設定（機密情報含む）
- `provider.tf.example`: プロバイダー設定の雛形

### 変数定義パターン
```terraform
variable "variable_name" {
  description = "明確な説明文を記述する"
  type        = string|number|bool|list(string)
}
```

### リソース命名
- VM: `proxmox_vm_qemu.vm`
- LXC: `proxmox_lxc.basic`
- 一貫性のある命名パターンを使用

### モジュール参照
```terraform
module "proxmox_vm" {
  source = "../../modules/proxmox_vm"
  # 相対パスを使用
}
```

## コメント規約
- 日本語コメントを積極的に使用
- 重要な設定には説明を追加
- Cloud-init設定などの技術的詳細にコメント

## セキュリティ規約
- 機密情報は`provider.tf`に記述（コミット対象外）
- サンプル値は安全なダミー値を使用
- APIトークンは環境変数または`terraform.tfvars`で管理