# Terraform環境の適用方法

## 事前準備

```sh
$ pwd # envs/exampleにいることを確認
~/terraform/envs/example
$ make tf-init
```

## 環境の作成

```sh
$ make tf-apply
```

## 環境の削除

```sh
$ make tf-destroy
```

## 環境のリセット

```sh
$ make tf-reset
```
