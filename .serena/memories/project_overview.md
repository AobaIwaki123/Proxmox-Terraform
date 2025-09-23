# Proxmox-Terraform プロジェクト概要

## プロジェクトの目的
Proxmox VE環境でVMとLXCコンテナを管理するためのTerraformフレームワーク。モジュール化されたアーキテクチャとテンプレートシステムを使用してインフラストラクチャをコードで管理する。

## 技術スタック
- **Terraform**: v1.13.3
- **tfenv**: 3.0.0 (Terraformバージョン管理)
- **Proxmox Provider**: 3.0.2-rc01 (VMとLXC共通)
- **Proxmox VE**: 8.3.0
- **Ubuntu Template**: 24.10
- **Task Runner**: Taskfile v3, Makefile

## プロジェクト構造
```
/
├── modules/           # 再利用可能なTerraformモジュール
│   ├── proxmox_vm/   # VM作成モジュール
│   └── proxmox_lxc/  # LXCコンテナ作成モジュール
├── template/         # 環境テンプレート
│   ├── vm/          # VM環境テンプレート
│   └── container/   # コンテナ環境テンプレート
├── envs/            # 実際の環境設定（動的に作成）
├── scripts/         # ユーティリティスクリプト
└── docs/            # ドキュメント
```

## 主要機能
1. **VM管理**: Proxmox VMの作成・設定・管理
2. **LXC管理**: Proxmox LXCコンテナの作成・設定・管理
3. **テンプレートシステム**: 再利用可能な環境テンプレート
4. **モジュール化**: 共通機能のモジュール化
5. **Task Runner**: 開発ワークフローの自動化