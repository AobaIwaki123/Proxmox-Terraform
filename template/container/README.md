# Terraform環境の適用方法(LXC Container)

このテンプレートは、Proxmox LXCコンテナ環境を作成するためのものです。
すべてのコマンドは、プロジェクトのルートディレクトリから実行してください。

## 事前準備

1. プロジェクトルートから環境を作成:
```sh
$ make create-ct ENV=<環境名>
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

- `hostname` : コンテナのホスト名
- `public_key` : コンテナにログインするための公開鍵
- `cores` : CPUのコア数
- `memory` : メモリのサイズ (MB)
- `disk_size` : ディスクのサイズ (GB)
- `ip_address` : コンテナに割り当てるIPアドレス（例: "192.168.11.100/24"）
- `gateway` : コンテナに割り当てるゲートウェイ（例: "192.168.11.1"）
- `nameserver` : DNSサーバー（例: "192.168.11.1"）
- `searchdomain` : 検索ドメイン（例: "localdomain"）
- `target_node` : Proxmoxのノード名
- `template` : LXCのテンプレート名（例: "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"）
- `storage` : コンテナのストレージ名（例: "local-lvm"）
- `bridge` : コンテナに割り当てるネットワークブリッジ（例: "vmbr0"）
- `vmid` : コンテナのID（例: 100）

## VMとの違い

LXCコンテナテンプレートは、VMテンプレートと以下の点が異なります：

- `username`パラメータが不要（LXCはrootユーザーで管理）
- テンプレートの形式が異なる（LXCテンプレートは`.tar.zst`形式）
- より軽量で起動が高速
