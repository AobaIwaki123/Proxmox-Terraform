# マイグレーションガイド

## 概要

このドキュメントは、Taskfileベースのワークフローから、Makefileベースのワークフローへの移行についてまとめたものです。

## 変更内容

### 1. ビルドツールの統一（Taskfile → Makefile）

**変更前:**
- プロジェクトルートに`Taskfile.yml`
- 各環境テンプレートに`Taskfile.yml`や`Makefile`が混在

**変更後:**
- プロジェクトルートに`Makefile`のみ
- すべての操作をルートから実行可能
- Taskコマンドのインストールが不要

### 2. コマンド体系の改善

**変更前:**
```bash
# 環境作成
$ task create-vm -- VM_NAME
$ task create-ct -- CT_NAME

# Terraform操作（各環境ディレクトリで実行）
$ cd envs/dev
$ task init-tf
$ task apply-tf
```

**変更後:**
```bash
# 環境作成
$ make create-vm ENV=VM_NAME
$ make create-ct ENV=CT_NAME

# Terraform操作（ルートから実行）
$ make init ENV=dev
$ make apply ENV=dev

# 環境一覧
$ make list
```

### 3. スクリプトの整理

**追加されたスクリプト:**
- `scripts/create-env.sh` - 環境作成
- `scripts/terraform-wrapper.sh` - Terraform操作のラッパー
- `scripts/list-envs.sh` - 環境一覧表示
- `scripts/setup-provider.sh` - プロバイダー設定

### 4. ファイル命名の修正

**修正内容:**
- `varialbles.tf` → `variables.tf` に統一

### 5. プロバイダー設定の改善

**変更前:**
- モジュールレベルに`provider.tf`を配置
- 全環境で共通のプロバイダー設定

**変更後:**
- 各環境ディレクトリに`provider.tf`を配置（推奨）
- モジュールレベルの配置も後方互換性のためサポート
- テンプレートに`provider.tf.example`を追加

```bash
# 環境ごとのプロバイダー設定（推奨）
$ make setup-provider ENV=dev

# モジュールレベルのプロバイダー設定（後方互換性）
$ make setup-provider
```

### 6. バージョン情報の更新

**修正内容:**
- Terraform: v1.13.3 → v1.9.8
- Proxmox: 8.3.4 → 8.3.0
- Proxmox Provider: 3.0.1-rc6 → 3.0.2-rc01

### 7. READMEの改善

- コマンド体系をMakefileベースに更新
- ワークフローの説明を明確化
- 各テンプレートのREADMEも更新

## 利用可能なコマンド

### 環境管理

```bash
# 環境一覧
$ make list

# VM環境の作成
$ make create-vm ENV=<name>

# Container環境の作成
$ make create-ct ENV=<name>

# 全環境の削除（注意！）
$ make delete-all
```

### Terraform操作

すべてのコマンドで`ENV=<name>`が必須です。

```bash
# 初期化
$ make init ENV=<name>

# 実行計画
$ make plan ENV=<name>

# 適用
$ make apply ENV=<name>

# 削除
$ make destroy ENV=<name>

# 状態ファイルのクリーンアップ
$ make clean ENV=<name>

# 検証
$ make validate ENV=<name>

# フォーマット
$ make fmt ENV=<name>
```

### セットアップ

```bash
# プロバイダー設定（モジュールレベル）
$ make setup-provider

# プロバイダー設定（環境ごと、推奨）
$ make setup-provider ENV=<name>
```

## 既存環境からの移行手順

既存の環境がある場合は、以下の手順で移行してください：

1. **既存のTaskfile/Makefileを削除**
   ```bash
   $ cd envs/<your-env>
   $ rm Taskfile.yml Makefile 2>/dev/null || true
   ```

2. **ファイル名を修正**
   ```bash
   $ cd envs/<your-env>
   $ mv varialbles.tf variables.tf 2>/dev/null || true
   ```

3. **プロバイダー設定を追加（オプション）**
   ```bash
   $ make setup-provider ENV=<your-env>
   # provider.tfを編集してAPI認証情報を設定
   ```

4. **新しいコマンドでテスト**
   ```bash
   $ make validate ENV=<your-env>
   $ make plan ENV=<your-env>
   ```

## トラブルシューティング

### コマンドが見つからない

**症状:**
```
make: command not found
```

**解決策:**
makeがインストールされていることを確認してください。
```bash
# Ubuntu/Debian
$ sudo apt install make

# RHEL/CentOS
$ sudo yum install make

# macOS
$ xcode-select --install
```

### ENV変数が必須

**症状:**
```
Error: ENV is required. Usage: make init ENV=<name>
```

**解決策:**
すべてのTerraform操作コマンドでは`ENV=<name>`を指定してください。

### 環境が見つからない

**症状:**
```
Error: Environment 'xxx' does not exist
```

**解決策:**
1. 環境が作成されているか確認: `make list`
2. 環境名のスペルが正しいか確認
3. 必要に応じて環境を作成: `make create-vm ENV=xxx`

## 今後の改善予定

PLAN.mdに記載されている以下の課題は、今後対応予定です：

- [ ] 環境のグループ化機能（例: envs/k8s-clusters/内の複数環境の一括操作）
- [ ] IPアドレス管理機能（重複チェック、可視化）
- [ ] リモートステート設定のサポート
- [ ] エラーハンドリング・ロールバック機能の強化
- [ ] テンプレートの柔軟性向上
- [ ] 環境の命名規則の統一

## 参考

- [README.md](./README.md) - プロジェクト全体のドキュメント
- [template/vm/README.md](./template/vm/README.md) - VM環境のドキュメント
- [template/container/README.md](./template/container/README.md) - Container環境のドキュメント
- [PLAN.md](./PLAN.md) - プロジェクトの課題と計画
