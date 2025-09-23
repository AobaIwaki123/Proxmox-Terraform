#!/bin/bash

# Proxmox WebUI Backend API テストスクリプト（Docker版）
# 
# 使用方法:
# 1. Docker Composeでサービスを起動: docker compose up -d
# 2. このスクリプトを実行: ./test_api.sh

# Docker環境に合わせたAPI Base URL
if [ "$1" = "docker" ]; then
    API_BASE="http://backend:8080"
    echo "=== Docker環境でのProxmox WebUI Backend API テスト ==="
else
    API_BASE="http://localhost:8080"
    echo "=== ローカル環境でのProxmox WebUI Backend API テスト ==="
fi

echo ""

# ヘルスチェック
echo "1. ヘルスチェック:"
if curl -s --connect-timeout 5 "${API_BASE}/ping" > /tmp/health_check.json 2>/dev/null; then
    cat /tmp/health_check.json | jq . 2>/dev/null || cat /tmp/health_check.json
    echo ""
else
    echo "❌ ヘルスチェック失敗 - サーバーが起動していないか、接続できません"
    echo ""
    exit 1
fi

# VMリスト取得
echo "2. VMリスト取得:"
if curl -s --connect-timeout 10 "${API_BASE}/api/vms" > /tmp/vms.json 2>/dev/null; then
    cat /tmp/vms.json | jq . 2>/dev/null || cat /tmp/vms.json
    echo ""
else
    echo "❌ VMリスト取得失敗"
    echo ""
fi

# LXCリスト取得  
echo "3. LXCリスト取得:"
if curl -s --connect-timeout 10 "${API_BASE}/api/lxcs" > /tmp/lxcs.json 2>/dev/null; then
    cat /tmp/lxcs.json | jq . 2>/dev/null || cat /tmp/lxcs.json
    echo ""
else
    echo "❌ LXCリスト取得失敗"
    echo ""
fi

# 統合リソース取得
echo "4. 統合リソース取得:"
if curl -s --connect-timeout 10 "${API_BASE}/api/resources" > /tmp/resources.json 2>/dev/null; then
    cat /tmp/resources.json | jq . 2>/dev/null || cat /tmp/resources.json
    echo ""
else
    echo "❌ 統合リソース取得失敗"
    echo ""
fi

# 一時ファイルの削除
rm -f /tmp/health_check.json /tmp/vms.json /tmp/lxcs.json /tmp/resources.json

echo "=== テスト完了 ==="
echo ""
echo "ℹ️  注意: Proxmox APIにアクセスできない場合は、以下を確認してください:"
echo "   - .envファイルでProxmox設定が正しく記入されているか"
echo "   - Proxmox VEサーバーが稼働し、ネットワーク接続が可能か"
echo "   - APIトークンが有効で適切な権限があるか"
