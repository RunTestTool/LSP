# DSM6 Docker 欄位對照表（LSP Calculator）

本表適用於 Synology DSM 6 的 **Docker** 套件（非 DSM7 Container Manager）。

## 一、建立容器前

- 映像檔來源：
  - 方案 A：從 `.tar` 匯入（建議）
  - 方案 B：從 Registry 拉取
- 建議映像標籤：`lsp-calculator:1.0`（或你自己的版本，例如 `1.1`）

## 二、DSM6「建立容器」欄位對照

| DSM6 畫面欄位 | 建議填寫 | 是否必填 | 說明 |
|---|---|---|---|
| 容器名稱 (Container Name) | `lsp-calculator` | 建議 | 容器識別名稱，可自訂 |
| 映像 (Image) | `lsp-calculator:1.0` | 必填 | 請選你匯入/拉取的版本 |
| 自動重新啟動 (Enable auto-restart) | 啟用 | 強烈建議 | NAS 重啟後自動拉起服務 |
| 執行指令 (Command) | **留空**（建議） | 否 | 用映像內建 CMD 最穩定 |
| 執行指令 (若必須填) | `streamlit run app.py --server.port=8501 --server.address=0.0.0.0` | 否 | 若 UI 要求覆蓋命令時使用 |
| 工作目錄 (Working Directory) | 留空 | 否 | 映像已設定 `/app` |
| 網路模式 (Network) | `bridge` | 建議 | 最常用且易於映射連接埠 |
| 本機連接埠 (Local Port) | `8501` | 必填 | 若衝突可改成 `18501` |
| 容器連接埠 (Container Port) | `8501` | 必填 | 固定為 Streamlit 服務埠 |
| Volume 掛載 | 不設定（一般情況） | 否 | 本工具一般不需持久化資料 |
| 環境變數：`STREAMLIT_SERVER_HEADLESS` | `true` | 否 | 映像已內建，可不填 |
| 環境變數：`STREAMLIT_BROWSER_GATHER_USAGE_STATS` | `false` | 否 | 映像已內建，可不填 |
| CPU 限制 | 先不限制（預設） | 否 | NAS 若多人共用再調整 |
| 記憶體限制 | 先不限制（預設） | 否 | 若要限制，建議先從 1024MB 起 |

## 三、連接埠範例

### 標準（推薦）

- Local Port: `8501`
- Container Port: `8501`
- 開啟網址：`http://<NAS-IP>:8501`

### 若 8501 被占用

- Local Port: `18501`
- Container Port: `8501`
- 開啟網址：`http://<NAS-IP>:18501`

## 四、啟動後驗證（5 點）

- [ ] 可開啟 `http://<NAS-IP>:8501`（或你設定的本機連接埠）
- [ ] 首頁正常顯示，無 500/空白頁
- [ ] 可上傳測試 CSV/XLSX
- [ ] 按「Generate Report / 生成審計底稿」有結果表
- [ ] 可下載 Excel 工作底稿

可選健康檢查網址：

```text
http://<NAS-IP>:8501/_stcore/health
```

一般預期回應為 `ok`。

## 五、更新時欄位怎麼填

更新時建議以「新映像標籤 + 新容器」方式：

1. 匯入新映像（例如 `lsp-calculator:1.1`）
2. 停用舊容器
3. 用同樣欄位建立新容器（同樣 port 映射）
4. 驗證通過後再刪舊容器

## 六、快速故障排除

- 開不到頁面：
  - 檢查容器是否 `Running`
  - 檢查 Port Mapping 是否 `本機:8501 -> 容器:8501`
  - 檢查是否錯填 `--server.address=localhost`（應為 `0.0.0.0`）
- 一直重啟：
  - 先移除手動 Command，改用「留空」讓映像預設啟動
- 連接埠衝突：
  - 改本機 port（例如 `18501 -> 8501`）

## 七、一句話建議

DSM6 最穩定配置是：**Command 留空 + Bridge 網路 + 8501:8501 + Auto-restart 開啟**。

---

延伸文件：

- `SYNOLOGY_NAS.md`
- `NAS_IMAGE_IMPORT.md`
- `UPDATE_CHECKLIST.md`
