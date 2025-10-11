package main

import (
	"crypto/tls"
	"encoding/json"
	"fmt"
	"io"
	"log"
  "net/http"
	"os"
	"time"

	"github.com/gin-contrib/cors"
  "github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

// ProxmoxClient Proxmox API クライアント構造体
type ProxmoxClient struct {
	BaseURL     string
	TokenID     string
	TokenSecret string
	HTTPClient  *http.Client
}

// VM VMの情報を格納する構造体
type VM struct {
	VMID        int     `json:"vmid"`
	Name        string  `json:"name"`
	Status      string  `json:"status"`
	CPU         float64 `json:"cpu"`
	Memory      int64   `json:"mem"`
	MaxMemory   int64   `json:"maxmem"`
	Disk        int64   `json:"disk"`
	MaxDisk     int64   `json:"maxdisk"`
	Uptime      int64   `json:"uptime"`
	Node        string  `json:"node"`
	Type        string  `json:"type"`
}

// LXC LXCコンテナの情報を格納する構造体
type LXC struct {
	VMID        int     `json:"vmid"`
	Name        string  `json:"name"`
	Status      string  `json:"status"`
	CPU         float64 `json:"cpu"`
	Memory      int64   `json:"mem"`
	MaxMemory   int64   `json:"maxmem"`
	Disk        int64   `json:"disk"`
	MaxDisk     int64   `json:"maxdisk"`
	Uptime      int64   `json:"uptime"`
	Node        string  `json:"node"`
	Type        string  `json:"type"`
}

// ProxmoxResponse Proxmox APIからのレスポンス構造体
type ProxmoxResponse struct {
	Data []map[string]interface{} `json:"data"`
}

// NewProxmoxClient Proxmoxクライアントの初期化
func NewProxmoxClient(baseURL, tokenID, tokenSecret string, insecure bool) *ProxmoxClient {
	client := &http.Client{
		Timeout: 30 * time.Second,
	}

	if insecure {
		tr := &http.Transport{
			TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
		}
		client.Transport = tr
	}

	return &ProxmoxClient{
		BaseURL:     baseURL,
		TokenID:     tokenID,
		TokenSecret: tokenSecret,
		HTTPClient:  client,
	}
}

// makeRequest Proxmox APIへのリクエストを実行
func (pc *ProxmoxClient) makeRequest(endpoint string) (*ProxmoxResponse, error) {
	url := fmt.Sprintf("%s%s", pc.BaseURL, endpoint)
	
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return nil, fmt.Errorf("リクエスト作成エラー: %v", err)
	}

	// API認証ヘッダーを設定
	authHeader := fmt.Sprintf("PVEAPIToken=%s=%s", pc.TokenID, pc.TokenSecret)
	req.Header.Set("Authorization", authHeader)
	req.Header.Set("Content-Type", "application/json")

	resp, err := pc.HTTPClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("APIリクエストエラー: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("APIエラー (status: %d): %s", resp.StatusCode, string(body))
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("レスポンス読み取りエラー: %v", err)
	}

	var proxmoxResp ProxmoxResponse
	if err := json.Unmarshal(body, &proxmoxResp); err != nil {
		return nil, fmt.Errorf("JSONパースエラー: %v", err)
	}

	return &proxmoxResp, nil
}

// GetVMs 全ノードのVMリストを取得
func (pc *ProxmoxClient) GetVMs() ([]VM, error) {
	// まずノードリストを取得
	nodesResp, err := pc.makeRequest("/nodes")
	if err != nil {
		return nil, fmt.Errorf("ノードリスト取得エラー: %v", err)
	}

	var vms []VM
	
	// 各ノードのVMを取得
	for _, nodeData := range nodesResp.Data {
		nodeName, ok := nodeData["node"].(string)
		if !ok {
			continue
		}

		endpoint := fmt.Sprintf("/nodes/%s/qemu", nodeName)
		vmResp, err := pc.makeRequest(endpoint)
		if err != nil {
			log.Printf("ノード %s のVM取得エラー: %v", nodeName, err)
			continue
		}

		// VMデータを構造体に変換
		for _, vmData := range vmResp.Data {
			vm := VM{
				Node: nodeName,
				Type: "qemu",
			}

			if vmid, ok := vmData["vmid"].(float64); ok {
				vm.VMID = int(vmid)
			}
			if name, ok := vmData["name"].(string); ok {
				vm.Name = name
			}
			if status, ok := vmData["status"].(string); ok {
				vm.Status = status
			}
			if cpu, ok := vmData["cpu"].(float64); ok {
				vm.CPU = cpu
			}
			if mem, ok := vmData["mem"].(float64); ok {
				vm.Memory = int64(mem)
			}
			if maxmem, ok := vmData["maxmem"].(float64); ok {
				vm.MaxMemory = int64(maxmem)
			}
			if disk, ok := vmData["disk"].(float64); ok {
				vm.Disk = int64(disk)
			}
			if maxdisk, ok := vmData["maxdisk"].(float64); ok {
				vm.MaxDisk = int64(maxdisk)
			}
			if uptime, ok := vmData["uptime"].(float64); ok {
				vm.Uptime = int64(uptime)
			}

			vms = append(vms, vm)
		}
	}

	return vms, nil
}

// GetLXCs 全ノードのLXCコンテナリストを取得
func (pc *ProxmoxClient) GetLXCs() ([]LXC, error) {
	// まずノードリストを取得
	nodesResp, err := pc.makeRequest("/nodes")
	if err != nil {
		return nil, fmt.Errorf("ノードリスト取得エラー: %v", err)
	}

	var lxcs []LXC
	
	// 各ノードのLXCを取得
	for _, nodeData := range nodesResp.Data {
		nodeName, ok := nodeData["node"].(string)
		if !ok {
			continue
		}

		endpoint := fmt.Sprintf("/nodes/%s/lxc", nodeName)
		lxcResp, err := pc.makeRequest(endpoint)
		if err != nil {
			log.Printf("ノード %s のLXC取得エラー: %v", nodeName, err)
			continue
		}

		// LXCデータを構造体に変換
		for _, lxcData := range lxcResp.Data {
			lxc := LXC{
				Node: nodeName,
				Type: "lxc",
			}

			if vmid, ok := lxcData["vmid"].(float64); ok {
				lxc.VMID = int(vmid)
			}
			if name, ok := lxcData["name"].(string); ok {
				lxc.Name = name
			}
			if status, ok := lxcData["status"].(string); ok {
				lxc.Status = status
			}
			if cpu, ok := lxcData["cpu"].(float64); ok {
				lxc.CPU = cpu
			}
			if mem, ok := lxcData["mem"].(float64); ok {
				lxc.Memory = int64(mem)
			}
			if maxmem, ok := lxcData["maxmem"].(float64); ok {
				lxc.MaxMemory = int64(maxmem)
			}
			if disk, ok := lxcData["disk"].(float64); ok {
				lxc.Disk = int64(disk)
			}
			if maxdisk, ok := lxcData["maxdisk"].(float64); ok {
				lxc.MaxDisk = int64(maxdisk)
			}
			if uptime, ok := lxcData["uptime"].(float64); ok {
				lxc.Uptime = int64(uptime)
			}

			lxcs = append(lxcs, lxc)
		}
	}

	return lxcs, nil
}

func main() {
	// 環境変数をロード (.envファイルが存在する場合)
	if err := godotenv.Load(); err != nil {
		log.Printf("Warning: .envファイルが見つかりません: %v", err)
	}

	// 環境変数から設定を取得
	proxmoxURL := os.Getenv("PROXMOX_API_URL")
	tokenID := os.Getenv("PROXMOX_API_TOKEN_ID")
	tokenSecret := os.Getenv("PROXMOX_API_TOKEN_SECRET")
	tlsInsecure := os.Getenv("PROXMOX_TLS_INSECURE") == "TRUE"

	if proxmoxURL == "" || tokenID == "" || tokenSecret == "" {
		log.Fatal("必要な環境変数が設定されていません: PROXMOX_API_URL, PROXMOX_API_TOKEN_ID, PROXMOX_API_TOKEN_SECRET")
	}

	// Proxmoxクライアントを初期化
	proxmoxClient := NewProxmoxClient(proxmoxURL, tokenID, tokenSecret, tlsInsecure)

	// Ginルーターを作成
  r := gin.Default()
  
	// CORSミドルウェアを設定
	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"http://localhost:3000"}, // フロントエンドのURL
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Accept", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}))

	// ヘルスチェックエンドポイント
  r.GET("/ping", func(c *gin.Context) {
    c.JSON(http.StatusOK, gin.H{
      "message": "pong",
    })
  })
  
	// VMリスト取得エンドポイント
	r.GET("/api/vms", func(c *gin.Context) {
		vms, err := proxmoxClient.GetVMs()
		if err != nil {
			log.Printf("VM取得エラー: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{
				"error":   "VMリスト取得に失敗しました",
				"details": err.Error(),
			})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"data":  vms,
			"count": len(vms),
		})
	})

	// LXCリスト取得エンドポイント
	r.GET("/api/lxcs", func(c *gin.Context) {
		lxcs, err := proxmoxClient.GetLXCs()
		if err != nil {
			log.Printf("LXC取得エラー: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{
				"error":   "LXCリスト取得に失敗しました",
				"details": err.Error(),
			})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"data":  lxcs,
			"count": len(lxcs),
		})
	})

	// 全リソース（VM + LXC）取得エンドポイント
	r.GET("/api/resources", func(c *gin.Context) {
		vms, err := proxmoxClient.GetVMs()
		if err != nil {
			log.Printf("VM取得エラー: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{
				"error":   "リソース取得に失敗しました",
				"details": err.Error(),
			})
			return
		}

		lxcs, err := proxmoxClient.GetLXCs()
		if err != nil {
			log.Printf("LXC取得エラー: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{
				"error":   "リソース取得に失敗しました", 
				"details": err.Error(),
			})
			return
		}

		// VMとLXCを統合したレスポンスを作成
		resources := make([]interface{}, 0, len(vms)+len(lxcs))
		for _, vm := range vms {
			resources = append(resources, vm)
		}
		for _, lxc := range lxcs {
			resources = append(resources, lxc)
		}

		c.JSON(http.StatusOK, gin.H{
			"data": gin.H{
				"vms":       vms,
				"lxcs":      lxcs,
				"resources": resources,
			},
			"count": gin.H{
				"vms":   len(vms),
				"lxcs":  len(lxcs),
				"total": len(vms) + len(lxcs),
			},
		})
	})

	log.Println("サーバーを開始中... http://localhost:8080")
	r.Run(":8080")
}
