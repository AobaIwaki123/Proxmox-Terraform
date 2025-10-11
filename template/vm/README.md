# Terraform環境の適用方法(VM)

このテンプレートは、Proxmox VM環境を作成するためのものです。
すべてのコマンドは、プロジェクトのルートディレクトリから実行してください。

## 事前準備

1. プロジェクトルートから環境を作成:
```sh
$ make create-vm ENV=<環境名>
```

2. `envs/<環境名>/terraform.tfvars`を編集して、パラメータを設定

3. プロバイダー設定ファイルを作成（初回のみ）:
```sh
$ make setup-provider ENV=<環境名>
```

4. `envs/<環境名>/provider.tf`を編集して、Proxmox API認証情報を設定

## 環境の初期化

```sh
$ make init ENV=<環境名>
```

## 実行計画の確認

```sh
$ make plan ENV=<環境名>
```

## 環境の作成

```sh
$ make apply ENV=<環境名>
```

## 環境の削除

```sh
$ make destroy ENV=<環境名>
```

## 環境のリセット（状態ファイルの削除）

```sh
$ make clean ENV=<環境名>
```

## その他のコマンド

```sh
# 環境一覧を表示
$ make list

# 設定ファイルの検証
$ make validate ENV=<環境名>

# 設定ファイルのフォーマット
$ make fmt ENV=<環境名>
```

## 指定できるパラメータ

以下のパラメータを`terraform.tfvars`で設定してください：

- `hostname` : VMのホスト名
- `username` : VMにログインするユーザ名
- `public_key` : VMにログインするための公開鍵
- `cores` : CPUのコア数
- `memory` : メモリのサイズ (MB)
- `disk_size` : ディスクのサイズ (GB)
- `ip_address` : VMに割り当てるIPアドレス（例: "192.168.11.100/24"）
- `gateway` : VMに割り当てるゲートウェイ（例: "192.168.11.1"）
- `nameserver` : DNSサーバー（例: "192.168.11.1"）
- `searchdomain` : 検索ドメイン（例: "localdomain"）
- `target_node` : Proxmoxのノード名
- `template` : VMのテンプレート名（例: "ubuntu-24.10a"）
- `storage` : VMのストレージ名（例: "local-lvm"）
- `bridge` : VMに割り当てるネットワークブリッジ（例: "vmbr0"）
- `vmid` : VMのID（例: 100）
