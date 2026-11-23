# VM 一覧からの Terraform 実行

この構成は一覧を使う検証用の入口です。既存 `envs/` の state は参照せず、
既存 VM は自動的には引き継ぎません。既存 VM の移行には別途 state の移行手順が必要です。

`terraform.tfvars.example` を `terraform.tfvars` にコピーし、共通設定と VM 一覧を編集します。
VM のキーがホスト名と Terraform のアドレスになるため、変更には state の移動が必要です。

プロバイダー設定はこのディレクトリの未追跡の `provider.tf` に用意します。
認証情報は Git にコミットしないでください。初期化して差分を確認します。

```sh
terraform init
terraform plan
```

一覧をまとめて一つの state で管理します。`plan` は一覧全体を対象にします。
