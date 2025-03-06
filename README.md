# Create Proxmox VM/Container with Terraform

自前のProxmox環境にVMやコンテナを立てるためのTerraformフレームワーク。  
基本的なコマンドは、Taskfileに集約し、基礎となる環境ファイルは`template`ディレクトリに格納している。  
公式のドキュメントは[こちら](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/guides/cloud-init%2520getting%2520started)。  
絶賛`3.0.1`開発中のProxmox Providerのリポジトリは[こちら](https://github.com/Telmate/terraform-provider-proxmox)。

# Version情報

- Ubuntu (OS Template): 24.10
- Terraform: v1.9.8
- tfenv: 3.0.0
- Proxmox: 8.3.0
- proxmox provider: 3.0.1-rc6
  - Containerに関しては、`rc5`, `rc6`において[こちら](https://github.com/Telmate/terraform-provider-proxmox/issues/1172)のISSUEが存在するため、`rc4`を使用している
 
# Gettig Started

## Terraformのインストール

```sh
$ sudo make init # 必要なapt packageのインストール
$ make install-tfenv # tfenvのインストール
```

## Proxmox API Tokenの取得

Tokenの作成手順については、[こちら](https://qiita.com/ymbk990/items/bd3973d2b858eb86e334#api%E3%83%88%E3%83%BC%E3%82%AF%E3%83%B3%E3%81%AE%E5%8F%96%E5%BE%97)を参考にしました。

```sh
$ pvesh create /access/users/root@pam/token/sample --privsep 0
┌──────────────┬──────────────────────────────────────┐
│ key          │ value                                │
╞══════════════╪══════════════════════════════════════╡
│ full-tokenid │ root@pam!sample                      │
├──────────────┼──────────────────────────────────────┤
│ info         │ {"privsep":"0"}                      │
├──────────────┼──────────────────────────────────────┤
│ value        │ ed1c77c5-3738-43d0-bd07-ffc7b25977fd │
└──────────────┴──────────────────────────────────────┘
```

## Provider情報のコピー

- TOKENをべたがきするようになっているため、流出に注意

```sh
$ make copy-provider
# modules/proxmox_vm/provider.tfが作成される
```

`provider.tf`にProxmox API Tokenの情報を記述する

## VMテンプレートの作成

以下のコマンドをproxmoxのノード上で実行する
スクリプトは[こちら](https://qiita.com/ymbk990/items/bd3973d2b858eb86e334)を参考にしました。  
コピペ用は[こちら](./scripts/create-vm-template.sh)。

```bash
$ wget https://cloud-images.ubuntu.com/oracular/current/oracular-server-cloudimg-amd64.img -O ubuntu-24.10-server-cloudimg-amd64.img
# Base VM configuration
$ qm create 9200 --net0 virtio,bridge=vmbr0
$ qm importdisk 9200 ubuntu-24.10-server-cloudimg-amd64.img local-lvm
$ qm set 9200 --name ubuntu-24.10a
$ qm set 9200 --scsihw virtio-scsi-pci --virtio0 local-lvm:vm-9200-disk-0
$ qm set 9200 --boot order=virtio0
$ qm set 9200 --ide2 local-lvm:cloudinit
$ qm set 9200 --nameserver 127.0.0.53 --searchdomain localdomain
# Convert VM to VM Template
$ qm template 9200
$ task create-provider
```

## 目的毎にTerraformの設定ファイル(env)を作成する

- 初めてこのリポジトリを使う場合は、既存のenvを削除する

```sh
$ task delete-all-envs
```

- 以下のコマンドでenvを作成する

```bash
$ task create-vm -- VM_NAME
$ task create-ct -- CT_NAME
```

`envs/dev/terraform.tfvars`を適宜編集する
以下はざっくりした説明

- hostname : VMのホスト名
- username : VMにログインするユーザ名
- public_key : VMにログインするための公開鍵
- cores : CPUのコア数
- memory : メモリのサイズ (MB)
- disk_size : ディスクのサイズ (GB)
- ip_address : VMに割り当てるIPアドレス
- gateway : VMに割り当てるゲートウェイ
- target_node : Proxmoxのノード名
- template : VMのテンプレート名
- storage : VMのストレージ名
- bride : VMに割り当てるネットワークブリッジ
- vmid : VMのID

## Terraform環境の適用方法

```sh
$ cd envs/dev
$ make tf-init
$ make tf-apply
```

[こちら](./envs/example/README.md)に詳しい手順が記載されています。

# 参考

- [Proxmox VEとTerraformでインターン生に仮想マシンを払い出す話](https://qiita.com/ymbk990/items/bd3973d2b858eb86e334)
詳しい説明は、それぞれのTemplateのREADMEを参照

# Docs

- [Terraformのインストール](./docs/install_terraform.md)
- [VMテンプレートの作成](./docs/create_vm_template.md)
