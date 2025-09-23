# Docker環境でのProxmox WebUI セットアップガイド

このガイドでは、Docker Composeを使用してProxmox WebUIを起動し、APIをテストする方法を説明します。

## 🚀 クイックスタート

### 1. 環境設定

`.env`ファイルを作成してProxmox VE接続情報を設定します：

```bash
cd Proxmox-WebUI
cp backend/example.env .env
```

`.env`ファイルを編集：

```env
PROXMOX_API_URL=https://YOUR_PROXMOX_SERVER_IP:8006/api2/json
PROXMOX_API_TOKEN_ID=YOUR_API_TOKEN_ID
PROXMOX_API_TOKEN_SECRET=YOUR_API_TOKEN_SECRET
PROXMOX_TLS_INSECURE=TRUE
PORT=8080
```

### 2. サービス起動

```bash
# すべてのサービスを起動
docker compose up -d

# ログを確認
docker compose logs -f
```

### 3. APIテスト実行

```bash
# 専用のテストサービスでAPIテストを実行
docker compose --profile test run --rm api-test

# または、手動でテストスクリプトを実行
docker compose exec backend /app/test_api.sh docker
```

## 📡 利用可能なエンドポイント

サービス起動後、以下のエンドポイントが利用できます：

- **フロントエンド**: http://localhost:3000
- **バックエンドAPI**: http://localhost:8080
- **ヘルスチェック**: http://localhost:8080/ping
- **VMリスト**: http://localhost:8080/api/vms
- **LXCリスト**: http://localhost:8080/api/lxcs
- **統合リソース**: http://localhost:8080/api/resources

## 🔧 Docker Compose コマンド

### 基本操作

```bash
# サービス起動（デタッチモード）
docker compose up -d

# サービス停止
docker compose down

# サービス再起動
docker compose restart

# ログ表示
docker compose logs -f [service_name]
```

### 開発時

```bash
# バックエンドのみ起動
docker compose up -d backend

# フロントエンドのみ起動  
docker compose up -d frontend

# サービス再ビルド
docker compose build

# 強制再ビルド
docker compose build --no-cache
```

### テスト

```bash
# APIテストを実行
docker compose --profile test run --rm api-test

# バックエンドコンテナでbashシェル起動
docker compose exec backend sh

# 手動テスト実行
docker compose exec backend ./test_api.sh docker
```

## 🛠️ トラブルシューティング

### サービス起動失敗

```bash
# サービス状態確認
docker compose ps

# 詳細ログ確認
docker compose logs backend
docker compose logs frontend
```

### API接続エラー

1. **環境変数確認**:
   ```bash
   docker compose exec backend env | grep PROXMOX
   ```

2. **ヘルスチェック確認**:
   ```bash
   curl http://localhost:8080/ping
   ```

3. **Proxmox接続テスト**:
   ```bash
   docker compose exec backend ./test_api.sh docker
   ```

### よくある問題

#### ポート競合

```bash
# 使用中のポートを確認
netstat -tulpn | grep :8080
netstat -tulpn | grep :3000

# 別のポートを使用する場合
PORT=8081 docker compose up -d
```

#### 権限エラー

```bash
# スクリプトに実行権限を付与
chmod +x backend/test_api.sh
```

#### ネットワーク問題

```bash
# Dockerネットワーク確認
docker network ls
docker compose ps

# コンテナ間通信テスト
docker compose exec frontend ping backend
```

## 📋 設定ファイル

### `.env`ファイル（必須）

```env
# Proxmox API設定
PROXMOX_API_URL=https://192.168.1.100:8006/api2/json
PROXMOX_API_TOKEN_ID=root@pam!your-token
PROXMOX_API_TOKEN_SECRET=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
PROXMOX_TLS_INSECURE=TRUE

# サーバー設定
PORT=8080
```

### `compose.override.yml`（オプション）

プロジェクト固有の設定変更用：

```yaml
services:
  backend:
    ports:
      - "8081:8080"  # ポート変更
    environment:
      - GIN_MODE=debug  # デバッグモード
  
  frontend:
    ports:
      - "3001:3000"  # ポート変更
```

## 🔐 セキュリティ

### プロダクション環境

```bash
# プロダクション用ビルド（将来の機能）
docker compose -f compose.yml -f compose.prod.yml up -d
```

### APIトークン管理

- APIトークンは`.env`ファイルで管理
- `.env`ファイルはバージョン管理に含めない
- 最小権限の原則に従ってAPIトークンを作成

## 📝 ログ管理

```bash
# リアルタイムログ監視
docker compose logs -f

# 特定サービスのログ
docker compose logs -f backend
docker compose logs -f frontend

# ログファイル出力
docker compose logs backend > backend.log 2>&1
```

## 🧹 クリーンアップ

```bash
# サービス停止とコンテナ削除
docker compose down

# ボリュームも削除
docker compose down -v

# イメージも削除
docker compose down --rmi all

# 完全なクリーンアップ
docker system prune -a
```
