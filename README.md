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

まず、以下のようにロール、ユーザーを作成し、作成したロールをユーザーに割り当てる。
以下のコマンドはPVEクラスタのノード上であればどこで実行しても良い。
また、GUIでも作成可能だがRoleは多少面倒なのでRoleだけはコマンドで作成するのがおすすめ。

### TerraformProvロールの作成

```sh
$ pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"
```

### terraform-provユーザーの作成

```sh
$ pveum user add terraform-prov@pve --password <password>
```

### TerraformProvロールをterraform-provユーザーに割り当てる

```sh
$ pveum aclmod / -user terraform-prov@pve -role TerraformProv
```

最後に作成したユーザーを用いてGUI上で任意のidでトークンを作成する。
以下のような画面が出ればOK

![alt text](imgs/tf-token.png)

## Provider情報のコピー

- TOKENをべたがきするようになっているため、流出に注意

```sh
$ task create-provider
# modules/proxmox_vm/provider.tf及び
# modules/proxmox_lxc/provider.tfが作成される
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
```

## 目的毎にTerraformの設定ファイル(env)を作成する

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
