# dotnet-vue-fullstack-skill

> 專為**繁體中文開發團隊**打造的 .NET Minimal API + Vue 3 全端腳手架 Skill for Claude Code

一句話描述：在 Claude Code 裡說一句「新增 API」或「建立頁面」，就幫你產生**符合現代架構慣例、且註解全是繁體中文**的後端 / 前端程式碼骨架。

## 為什麼用這個

多數腳手架工具產出的都是英文註解的樣板，對中文團隊來說 code review 與交接時還要再翻譯一次。這個 skill 的核心定位就是：

- **註解原生繁體中文**：命名用英文、說明用繁中，直接符合中文團隊的協作習慣，不用事後改
- **固定的分層架構**：產出的程式碼結構一致，多人協作不會各寫各的
- **型別安全加上文件註解**：後端 C# XML 文件註解、前端 JSDoc，IDE 提示與 API 文件一次到位

如果你的團隊用繁中溝通、技術棧是 .NET + Vue，這個 skill 能省下大量重複打樣板的時間。

## 產生內容

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

## 慣例

- 程式碼命名使用英文，註解使用繁體中文
- 後端使用 C# XML 文件註解 `/// <summary>`
- 前端使用 JSDoc `/** @description */`
- CSS 遵循 BEM 命名規則，響應式設計
- 完整的 TypeScript 型別定義

## 安裝

```bash
git clone https://github.com/CunXXX/dotnet-vue-fullstack-skill.git
cd dotnet-vue-fullstack-skill
bash install.sh
```

或使用 npx skills：

```bash
npx skills add CunXXX/dotnet-vue-fullstack-skill -g
```

## 觸發方式

在 Claude Code 中提到以下關鍵字即可觸發：
- 「新增 API」、「建立端點」
- 「新增元件」、「建立頁面」
- 「腳手架」、「scaffold」、「generate」、「產生模板」

## 授權

MIT License
