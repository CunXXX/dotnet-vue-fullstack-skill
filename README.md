# dotnet-vue-fullstack-skill

.NET Minimal API + Vue 3 全端腳手架 Skill for Claude Code

## 功能

自動產生符合現代架構慣例的全端程式碼骨架：

### 後端（.NET Minimal API）
- **Endpoint** — 路由定義（取代傳統 Controller）
- **Service** — 商業邏輯層（interface + 實作）
- **Repository** — 資料存取層（Raw SQL + IDBService）
- **DTO** — Request / Response（record 型別）
- **DbModel** — 資料庫實體（POCO class）

### 前端（Vue 3 + TypeScript）
- **View** — 頁面級元件（Composition API + script setup）
- **Component** — 可複用元件（Props + Emits）
- **Service** — API 呼叫（Axios + 型別安全）
- **Store** — Pinia 狀態管理（Composition API 風格）

## 特色

- 所有註解使用繁體中文
- 後端使用 C# XML 文件註解 `/// <summary>`
- 前端使用 JSDoc `/** @description */`
- CSS 遵循 BEM 命名規則
- 響應式設計
- 完整的 TypeScript 型別定義

## 安裝

```bash
git clone https://github.com/topcat-tc/dotnet-vue-fullstack-skill.git
cd dotnet-vue-fullstack-skill
bash install.sh
```

或使用 npx skills：

```bash
npx skills add topcat-tc/dotnet-vue-fullstack-skill -g
```

## 觸發方式

在 Claude Code 中提到以下關鍵字即可觸發：
- 「新增 API」、「建立端點」
- 「新增元件」、「建立頁面」
- 「腳手架」、「scaffold」、「generate」、「產生模板」

## 授權

MIT License
