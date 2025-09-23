# Proxmox-WebUI システム

## 概要
ProxmoxのAPIを使用して、ProxmoxのVM/LXCを管理するWebUIシステム。UI上からTerraformを実行することができ、一括作成・一括削除が可能。

## アーキテクチャ
- **Backend**: GoのAPIサーバー
- **Frontend**: Next.jsのUI
- **Container**: Docker Composeによる開発環境

## ディレクトリ構成
```
Proxmox-WebUI/
├── backend/          # Go APIサーバー
│   └── Dockerfile    # バックエンド用Dockerfile
├── frontend/         # Next.js UI
│   └── my-app/       # Next.jsアプリケーション
│       └── Dockerfile # フロントエンド用Dockerfile
├── README.md         # システム説明
├── Makefile          # ビルド・デプロイタスク
└── compose.yml       # Docker Compose設定
```

## 開発環境設定
### Docker Compose設定
- **Backend**: ポート8080で起動
  - 開発モード: `go run main.go`
  - ボリュームマウント: `./backend:/app`
- **Frontend**: ポート3000で起動
  - 開発モード: `bun dev`
  - ボリュームマウント: `./frontend/my-app:/app`

## 主要機能
1. **VM管理**: Proxmox VMの作成・削除・管理
2. **LXC管理**: Proxmox LXCコンテナの作成・削除・管理
3. **Terraform統合**: UI上からTerraformコマンド実行
4. **一括操作**: 複数リソースの一括作成・削除
5. **API連携**: Proxmox APIとの直接連携

## 技術スタック
- **Backend**: Go
- **Frontend**: Next.js
- **Runtime**: Bun (フロントエンド)
- **Container**: Docker, Docker Compose
- **API**: Proxmox API
- **Integration**: Terraform CLI