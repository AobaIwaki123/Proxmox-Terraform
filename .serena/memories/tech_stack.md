# 技術スタック詳細

## コア技術
- **Terraform**: v1.9.8 - インフラストラクチャのコード化
- **tfenv**: 3.0.0 - Terraformバージョン管理ツール
- **Proxmox Provider**: 3.0.2-rc01 - Proxmox VEとの統合

## インフラストラクチャ
- **Proxmox VE**: 8.3.0 - 仮想化プラットフォーム
- **Ubuntu**: 24.10 - ベースOSテンプレート
- **Cloud-init**: VM初期化設定

## 開発ツール
- **Taskfile**: v3 - タスクランナー
- **Makefile**: 追加のビルドタスク
- **Git**: バージョン管理

## WebUI管理システム
- **Docker Compose**: コンテナオーケストレーション
- **Frontend**: Web管理インターフェース
- **Backend**: APIサーバー
- **Makefile**: WebUI固有のビルド・デプロイタスク

## ネットワーク設定
- **ブリッジ**: vmbr0 (デフォルト)
- **IP範囲**: 192.168.11.x/24
- **ゲートウェイ**: 192.168.11.1

## ストレージ
- **デフォルトストレージ**: local-lvm
- **テンプレートストレージ**: cephfs (LXC用)

## ドキュメント管理
- **Markdown**: ドキュメント記述形式
- **README.md**: 各コンポーネントの説明
- **docs/**: プロジェクト全体のドキュメント管理

## バージョン管理
- **Terraform**: v1.9.8 (最新: v1.13.3)
- **Proxmox Provider**: 3.0.2-rc01 (安定版)
- **tfenv**: 3.0.0 (Terraformバージョン管理)