# Proxmox WebUI Backend

Proxmox VE環境のVMとLXCコンテナを管理するためのGo製RESTfulAPIサーバーです。

## 🚀 機能

- **VMリスト取得**: Proxmox VE環境の全VMの一覧取得
- **LXCリスト取得**: Proxmox VE環境の全LXCコンテナの一覧取得  
- **統合リソース取得**: VMとLXCを統合した一覧取得
- **ヘルスチェック**: APIサーバーの稼働状況確認

## 📋 必要な環境

- Go 1.25以上
- Proxmox VE 8.0以上
- Proxmox VE APIトークン

## ⚙️ セットアップ

### 1. 環境変数の設定

`example.env`をベースに`.env`ファイルを作成します：

```bash
cp example.env .env
```

`.env`ファイルを編集して、Proxmox VE環境に合わせて設定します：

```env
PROXMOX_API_URL=https://YOUR_PROXMOX_SERVER_IP:8006/api2/json
PROXMOX_API_TOKEN_ID=YOUR_API_TOKEN_ID
PROXMOX_API_TOKEN_SECRET=YOUR_API_TOKEN_SECRET
PROXMOX_TLS_INSECURE=TRUE
PORT=8080
```

### 2. Proxmox VE APIトークンの作成

1. Proxmox VE WebUIにログイン
2. **Datacenter** → **Permissions** → **API Tokens**
3. 新しいAPIトークンを作成
4. トークンIDとシークレットを`.env`ファイルに設定

### 3. 依存関係のインストール

```bash
go mod tidy
```

## 🔧 開発・起動

### 開発モード（ホットリロード）

```bash
go run main.go
```

### ビルド

```bash
go build -o proxmox-webui-backend main.go
```

## 📡 API エンドポイント

### ヘルスチェック

```
GET /ping
```

**レスポンス例:**
```json
{
  "message": "pong"
}
```

### VMリスト取得

```
GET /api/vms
```

**レスポンス例:**
```json
{
  "data": [
    {
      "vmid": 100,
      "name": "vm-ubuntu",
      "status": "running",
      "cpu": 0.02,
      "mem": 1073741824,
      "maxmem": 2147483648,
      "disk": 10737418240,
      "maxdisk": 21474836480,
      "uptime": 86400,
      "node": "pve",
      "type": "qemu"
    }
  ],
  "count": 1
}
```

### LXCリスト取得

```
GET /api/lxcs
```

**レスポンス例:**
```json
{
  "data": [
    {
      "vmid": 101,
      "name": "lxc-ubuntu",
      "status": "running",
      "cpu": 0.01,
      "mem": 536870912,
      "maxmem": 1073741824,
      "disk": 2147483648,
      "maxdisk": 10737418240,
      "uptime": 43200,
      "node": "pve",
      "type": "lxc"
    }
  ],
  "count": 1
}
```

### 統合リソース取得

```
GET /api/resources
```

**レスポンス例:**
```json
{
  "data": {
    "vms": [...],
    "lxcs": [...],
    "resources": [...]
  },
  "count": {
    "vms": 1,
    "lxcs": 1,
    "total": 2
  }
}
```

## 🏗️ Docker Compose との統合

このバックエンドは、プロジェクトルートの`compose.yml`でフロントエンドと一緒に起動できます：

```bash
# プロジェクトルートで実行
docker compose up -d
```

## 🛠️ トラブルシューティング

### API認証エラー

- APIトークンID/シークレットが正しく設定されているか確認
- Proxmox VE側でAPIトークンが有効になっているか確認
- 必要な権限（VM.Monitor, Container.Monitor等）が付与されているか確認

### TLS証明書エラー

自己署名証明書を使用している場合は、`PROXMOX_TLS_INSECURE=TRUE`を設定してください。

### ネットワーク接続エラー

- Proxmox VEサーバーのIPアドレスとポート(8006)が正しいか確認
- ファイアウォール設定を確認

## 📝 ログ

アプリケーションログは標準出力に出力されます。Docker環境では`docker compose logs backend`で確認できます。

## 🔐 セキュリティ

- APIトークンは環境変数またはDockerシークレットで管理
- プロダクション環境では有効なTLS証明書の使用を推奨
- 最小権限の原則に従ったAPIトークン権限設定

## 🚧 今後の拡張予定

- VM/LXC個別詳細情報取得
- VM/LXC操作機能（起動/停止/再起動）
- リアルタイム監視
- 認証機能の追加
