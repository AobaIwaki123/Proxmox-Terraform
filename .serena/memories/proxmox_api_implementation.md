# Proxmox API実装 - VM/LXCリスト取得機能

## 実装概要
GoバックエンドにProxmox VE APIクライアントを実装し、VMとLXCコンテナのリスト取得機能を追加しました。

## 実装済み機能

### APIエンドポイント
1. **ヘルスチェック**: `GET /ping`
2. **VMリスト取得**: `GET /api/vms`
3. **LXCリスト取得**: `GET /api/lxcs`
4. **統合リソース取得**: `GET /api/resources`

### 主要コンポーネント

#### ProxmoxClient構造体
- API認証（PVEAPIToken方式）
- TLS設定（自己署名証明書対応）
- HTTPタイムアウト設定（30秒）

#### データ構造
- VM構造体: VMID、名前、ステータス、CPU、メモリ、ディスク使用量等
- LXC構造体: VMと同様の情報を含む

#### セキュリティ設定
- CORS設定（フロントエンド `http://localhost:3000` からのアクセス許可）
- 環境変数による設定管理（`.env`ファイル対応）

## Docker環境統合

### compose.yml機能
- バックエンドサービスのヘルスチェック
- 環境変数の統合管理
- テスト用APIテストサービス（profile: test）

### テスト機能
- 自動化されたAPIテストスクリプト（test_api.sh）
- Docker環境とローカル環境の両対応
- curlベースの実行テスト

## 設定ファイル

### 環境変数（.env）
```env
PROXMOX_API_URL=https://SERVER_IP:8006/api2/json
PROXMOX_API_TOKEN_ID=TOKEN_ID
PROXMOX_API_TOKEN_SECRET=TOKEN_SECRET
PROXMOX_TLS_INSECURE=TRUE
```

### Goモジュール依存関係
- gin-gonic/gin: HTTPフレームワーク
- gin-contrib/cors: CORS設定
- joho/godotenv: 環境変数管理

## Docker Composeコマンド更新
プロジェクト全体で `docker-compose` から `docker compose` への統一変更を実施：
- 全ドキュメント（README、DOCKER_SETUP.md等）
- 設定ファイル（.cursor/rules内）
- テストスクリプト

## 使用方法

### 起動
```bash
docker compose up -d
```

### テスト実行
```bash
# 専用テストサービス
docker compose --profile test run --rm api-test

# 手動テスト
docker compose exec backend ./test_api.sh docker
```

## 今後の拡張予定
- VM/LXC操作機能（起動/停止/再起動）
- リアルタイム監視
- 認証機能
- 詳細情報取得API