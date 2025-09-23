# プロジェクト構造詳細

## ディレクトリ構成

### `/modules/` - 再利用可能なTerraformモジュール
- `proxmox_vm/`: VM作成用モジュール
  - `main.tf`: VMリソース定義
  - `variables.tf`: 変数定義
  - `outputs.tf`: 出力定義
  - `provider.tf.example`: プロバイダー設定雛形
  - `README.md`: モジュール説明
- `proxmox_lxc/`: LXCコンテナ作成用モジュール
  - 同様の構成

### `/template/` - 環境テンプレート
- `vm/`: VM環境テンプレート
  - `main.tf`: モジュール呼び出し
  - `varialbles.tf`: 変数定義（注意: スペルミス）
  - `terraform.tfvars`: 設定値サンプル
  - `Taskfile.yml`: 環境固有タスク
  - `README.md`: 使用方法
- `container/`: LXCコンテナ環境テンプレート
  - 同様の構成（username変数なし）

### `/envs/` - 実際の環境設定
- 動的に作成されるディレクトリ
- 各環境は`template/`からコピーして作成
- 例: `envs/dev/`, `envs/prod/`

### `/scripts/` - ユーティリティスクリプト
- `create-vm-template.sh`: VMテンプレート作成スクリプト

### `/docs/` - ドキュメント
- インストール手順、テンプレート作成手順など

## ファイル命名規則

### Terraformファイル
- `main.tf`: メインリソース定義
- `variables.tf`: 変数定義
- `outputs.tf`: 出力定義
- `provider.tf`: プロバイダー設定（機密情報含む）
- `provider.tf.example`: プロバイダー設定雛形
- `terraform.tfvars`: 設定値

### 設定ファイル
- `Taskfile.yml`: タスクランナー設定
- `Makefile`: 追加ビルドタスク
- `README.md`: ドキュメント

## 重要な注意点

### ファイル名の特殊性
- `varialbles.tf`: 正しくは`variables.tf`だが、プロジェクト全体で統一されている

### 機密情報の管理
- `provider.tf`は`.gitignore`に含める
- `provider.tf.example`をベースに作成
- APIトークンは環境変数で管理推奨