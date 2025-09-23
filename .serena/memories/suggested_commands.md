# 推奨コマンド集

## 環境セットアップ
```bash
# 必要なパッケージのインストール
sudo make init

# tfenvのインストール
make install-tfenv

# プロバイダー設定ファイルの作成
task create-provider
```

## 環境作成
```bash
# VM環境の作成
task create-vm -- VM_NAME

# LXCコンテナ環境の作成
task create-ct -- CT_NAME
```

## Terraform操作
```bash
# 環境ディレクトリに移動
cd envs/ENV_NAME

# Terraform初期化
terraform init

# 実行計画確認
terraform plan

# リソース適用
terraform apply

# リソース削除
terraform destroy
```

## 開発・メンテナンス
```bash
# コードフォーマット
terraform fmt

# 構文検証
terraform validate

# 全環境削除
task delete-all-envs

# Gitブランチクリーンアップ
make prune-br
```

## プロキシ設定（必要に応じて）
```bash
# プロキシ環境でのTerraform実行
export HTTP_PROXY=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080
export NO_PROXY=localhost,127.0.0.1
```

## デバッグ・トラブルシューティング
```bash
# 詳細ログ出力
TF_LOG=DEBUG terraform apply

# 状態ファイル確認
terraform show

# 状態ファイルリスト
terraform state list
```