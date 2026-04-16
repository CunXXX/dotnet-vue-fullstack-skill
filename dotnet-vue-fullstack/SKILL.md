---
name: dotnet-vue-fullstack
description: >
  .NET Minimal API + Vue 3 全端腳手架。自動產生 Endpoint、Service、Repository、DTO、
  Vue 元件、Pinia Store、TypeScript Service，遵循繁體中文註解與現代架構慣例。
  當使用者提到「新增 API」、「建立端點」、「新增元件」、「建立頁面」、「腳手架」、
  「scaffold」、「generate」、「產生模板」時請使用此 skill。
---

# .NET + Vue 3 全端腳手架 Skill

根據使用者需求，產生符合現代架構慣例的後端 / 前端程式碼骨架。
所有註解使用繁體中文，程式碼命名使用英文。

---

## 後端架構：.NET Minimal API

### 架構分層

```
Endpoints/   → 路由定義（取代傳統 Controller）
Services/    → 商業邏輯層（interface + 實作）
Repositories/ → 資料存取層（interface + 實作，Raw SQL）
Models/
  Requests/  → 請求 DTO（record）
  Responses/ → 回應 DTO（record）
DbModels/    → 資料庫實體（POCO class）
```

### 產生規則

#### 1. Endpoint（取代 Controller）

```csharp
/// <summary>
/// {功能}端點，處理{功能描述}
/// </summary>
public static class {Name}Endpoints
{
    /// <summary>
    /// 註冊所有{功能}相關的端點路由
    /// </summary>
    public static RouteGroupBuilder Map{Name}Endpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/{route}");
        group.WithTags("{Tag}");
        group.RequireAuthorization();

        // GET 列表
        group.MapGet("/", async (
            I{Name}Service service,
            CancellationToken ct) =>
        {
            var result = await service.GetAllAsync(ct);
            return Results.Ok(result);
        });

        // GET 單筆
        group.MapGet("/{id:guid}", async (
            Guid id,
            I{Name}Service service,
            CancellationToken ct) =>
        {
            var result = await service.GetByIdAsync(id, ct);
            return result is null ? Results.NotFound() : Results.Ok(result);
        });

        // POST 建立
        group.MapPost("/", async (
            Create{Name}Request request,
            I{Name}Service service,
            CancellationToken ct) =>
        {
            var result = await service.CreateAsync(request, ct);
            return Results.Created($"/api/{route}/{result.Id}", result);
        });

        // PUT 更新
        group.MapPut("/{id:guid}", async (
            Guid id,
            Update{Name}Request request,
            I{Name}Service service,
            CancellationToken ct) =>
        {
            var result = await service.UpdateAsync(id, request, ct);
            return result is null ? Results.NotFound() : Results.Ok(result);
        });

        // DELETE 刪除
        group.MapDelete("/{id:guid}", async (
            Guid id,
            I{Name}Service service,
            CancellationToken ct) =>
        {
            var deleted = await service.DeleteAsync(id, ct);
            return deleted ? Results.NoContent() : Results.NotFound();
        });

        return group;
    }
}
```

重點規則：
- 使用靜態類別 + 擴充方法，回傳 `RouteGroupBuilder`
- 依賴注入直接寫在 handler 參數
- 使用 `Results.*` 回傳模式
- 所有非同步方法傳遞 `CancellationToken`
- 路由用 kebab-case 複數形式（如 `/api/photos`）

#### 2. Service（商業邏輯）

```csharp
/// <summary>
/// {功能}服務介面
/// </summary>
public interface I{Name}Service
{
    /// <summary>
    /// 取得所有{功能}
    /// </summary>
    Task<IReadOnlyCollection<{Name}Response>> GetAllAsync(CancellationToken ct = default);

    /// <summary>
    /// 依 ID 取得{功能}
    /// </summary>
    Task<{Name}Response?> GetByIdAsync(Guid id, CancellationToken ct = default);

    /// <summary>
    /// 建立{功能}
    /// </summary>
    Task<{Name}Response> CreateAsync(Create{Name}Request request, CancellationToken ct = default);

    /// <summary>
    /// 更新{功能}
    /// </summary>
    Task<{Name}Response?> UpdateAsync(Guid id, Update{Name}Request request, CancellationToken ct = default);

    /// <summary>
    /// 刪除{功能}
    /// </summary>
    Task<bool> DeleteAsync(Guid id, CancellationToken ct = default);
}

/// <summary>
/// {功能}服務實作
/// </summary>
public class {Name}Service : I{Name}Service
{
    private readonly I{Name}Repository _repository;

    public {Name}Service(I{Name}Repository repository)
    {
        _repository = repository;
    }

    // 實作各方法，呼叫 Repository 並轉換為 Response DTO
}
```

重點規則：
- 介面 + 實作分離
- 建構子注入依賴，私有欄位加底線前綴 `_repository`
- 所有方法非同步，參數含 `CancellationToken ct = default`
- 回傳集合用 `IReadOnlyCollection<T>`
- 可為 null 的回傳用 `T?`

#### 3. Repository（資料存取）

```csharp
/// <summary>
/// {功能}資料存取介面
/// </summary>
public interface I{Name}Repository
{
    Task<IReadOnlyCollection<{Name}>> GetAllAsync(CancellationToken ct = default);
    Task<{Name}?> GetByIdAsync(Guid id, CancellationToken ct = default);
    Task<{Name}> CreateAsync({Name} entity, CancellationToken ct = default);
    Task<{Name}?> UpdateAsync({Name} entity, CancellationToken ct = default);
    Task<bool> DeleteAsync(Guid id, CancellationToken ct = default);
}

/// <summary>
/// {功能}資料存取實作
/// </summary>
public class {Name}Repository : I{Name}Repository
{
    private const string SelectColumns = """
        column_a AS PropertyA,
        column_b AS PropertyB,
        created_at AS CreatedAt
        """;

    private readonly IDBService _db;

    public {Name}Repository(IDBService db) => _db = db;

    /// <summary>
    /// 取得所有{功能}
    /// </summary>
    public async Task<IReadOnlyCollection<{Name}>> GetAllAsync(CancellationToken ct = default)
    {
        var sql = $"""
            SELECT {SelectColumns}
            FROM {table_name}
            ORDER BY created_at DESC
            """;
        return await _db.QueryAsync<{Name}>(sql);
    }

    /// <summary>
    /// 建立{功能}
    /// </summary>
    public async Task<{Name}> CreateAsync({Name} entity, CancellationToken ct = default)
    {
        var sql = $"""
            INSERT INTO {table_name} (column_a, column_b)
            VALUES (@PropertyA, @PropertyB)
            RETURNING {SelectColumns}
            """;
        return await _db.QueryFirstOrDefaultAsync<{Name}>(sql, entity)
            ?? throw new InvalidOperationException("Failed to create {name}.");
    }
}
```

重點規則：
- 使用 `IDBService` 抽象層（Dapper 風格）
- Raw SQL 使用 C# 原始字串 `""" """`
- SELECT 欄位抽成 `SelectColumns` 常數，snake_case 對映 PascalCase
- 參數綁定用 `@PropertyName`
- 建立失敗拋 `InvalidOperationException`

#### 4. DTO（Request / Response）

```csharp
// Models/Requests/{Name}Requests.cs

/// <summary>
/// 建立{功能}請求
/// </summary>
public record Create{Name}Request(string PropertyA, string PropertyB);

/// <summary>
/// 更新{功能}請求
/// </summary>
public record Update{Name}Request(string PropertyA, string PropertyB);
```

```csharp
// Models/Responses/{Name}Response.cs

/// <summary>
/// {功能}回應模型
/// </summary>
public record {Name}Response(
    Guid Id,
    string PropertyA,
    string PropertyB,
    DateTimeOffset CreatedAt);

/// <summary>
/// {功能}映射擴充方法
/// </summary>
public static class {Name}MappingExtensions
{
    /// <summary>
    /// 將 {Name} 轉換為 {Name}Response
    /// </summary>
    public static {Name}Response ToResponse(this {Name} entity)
        => new(entity.Id, entity.PropertyA, entity.PropertyB, entity.CreatedAt);
}
```

重點規則：
- 使用 `record` 而非 `class`
- 位置語法定義屬性（positional record）
- 映射用擴充方法 `ToResponse()`

#### 5. DbModel（資料庫實體）

```csharp
// DbModels/{Name}.cs

/// <summary>
/// {功能}資料庫實體
/// </summary>
public class {Name}
{
    /// <summary>
    /// {功能} ID
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// 屬性描述
    /// </summary>
    public string PropertyA { get; set; } = string.Empty;

    /// <summary>
    /// 建立時間
    /// </summary>
    public DateTimeOffset CreatedAt { get; set; }
}
```

重點規則：
- 簡單 POCO class，public auto-properties
- 字串初始化為 `string.Empty`
- 時間用 `DateTimeOffset`
- 可為空的欄位用 `string?`、`DateTimeOffset?`

#### 6. DI 註冊（Program.cs 片段）

產生程式碼後，提醒使用者在 `Program.cs` 加入：

```csharp
// Repository
builder.Services.AddScoped<I{Name}Repository, {Name}Repository>();
// Service
builder.Services.AddScoped<I{Name}Service, {Name}Service>();
```

以及在端點註冊區加入：

```csharp
app.Map{Name}Endpoints();
```

---

## 前端架構：Vue 3 + TypeScript + Composition API

### 架構分層

```
views/        → 頁面級元件（搭配 Router）
components/   → 可複用元件
services/     → API 呼叫與商業邏輯
stores/       → Pinia 狀態管理
```

### 產生規則

#### 1. 頁面元件（View）

```vue
<template>
  <div class="{name}">
    <div class="{name}__header">
      <h1 class="{name}__title">{標題}</h1>
    </div>
    <div class="{name}__content">
      <!-- 內容 -->
    </div>
  </div>
</template>

<script setup lang="ts">
/**
 * @description {頁面描述}
 */
import { ref, onMounted } from 'vue'
import { apiClient } from '@/services/apiClient'

// 型別定義
interface {Name}Item {
  id: string
  propertyA: string
  createdAt: string
}

// 響應式狀態
const items = ref<{Name}Item[]>([])
const loading = ref(false)

// 資料載入
async function loadItems() {
  loading.value = true
  try {
    const res = await apiClient.get<{Name}Item[]>('/api/{route}')
    items.value = res.data
  } catch (e) {
    console.error('載入失敗:', e)
  } finally {
    loading.value = false
  }
}

onMounted(loadItems)
</script>

<style scoped>
.{name} {
  padding: 24px 32px;
}

.{name}__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 24px;
}

.{name}__title {
  font-size: 1.5rem;
  font-weight: 600;
}

@media (max-width: 768px) {
  .{name} {
    padding: 16px 20px;
  }
}
</style>
```

重點規則：
- 使用 `<script setup lang="ts">`
- 開頭必須有 `/** @description ... */` 註解
- 介面定義在 script 區塊內
- 狀態用 `ref<T>()`
- 事件處理用一般函式，不用箭頭函式
- CSS 用 BEM 命名：`.block__element--modifier`
- 必須有 `scoped` 樣式
- 必須有響應式設計 `@media`

#### 2. 可複用元件（Component）

```vue
<template>
  <div class="{name}-card">
    <slot />
  </div>
</template>

<script setup lang="ts">
/**
 * @description {元件描述}
 */

// Props 定義
interface Props {
  title: string
  variant?: 'default' | 'outlined'
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'default'
})

// Emits 定義
const emit = defineEmits<{
  click: []
  close: []
}>()
</script>

<style scoped>
.{name}-card {
  border-radius: 8px;
  padding: 16px;
}
</style>
```

#### 3. TypeScript Service

```typescript
/**
 * @file {name}Service.ts
 * @description {服務描述}
 */
import { apiClient } from './apiClient'

// 型別匯出
export interface {Name}Response {
  id: string
  propertyA: string
  createdAt: string
}

export interface Create{Name}Request {
  propertyA: string
}

// API 呼叫
export async function getAll(): Promise<{Name}Response[]> {
  const res = await apiClient.get<{Name}Response[]>('/api/{route}')
  return res.data
}

export async function getById(id: string): Promise<{Name}Response> {
  const res = await apiClient.get<{Name}Response>(`/api/{route}/${id}`)
  return res.data
}

export async function create(request: Create{Name}Request): Promise<{Name}Response> {
  const res = await apiClient.post<{Name}Response>('/api/{route}', request)
  return res.data
}

export async function remove(id: string): Promise<void> {
  await apiClient.delete(`/api/{route}/${id}`)
}
```

重點規則：
- 檔案開頭必須有 `@file` 和 `@description`
- 使用具名匯出（named export）
- 明確的回傳型別
- 介面從 service 匯出，供元件使用

#### 4. Pinia Store

```typescript
/**
 * @file {name}.ts
 * @description {Store 描述}
 */
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { apiClient } from '@/services/apiClient'

export interface {Name}State {
  id: string
  propertyA: string
}

export const use{Name}Store = defineStore('{name}', () => {
  // 狀態
  const items = ref<{Name}State[]>([])
  const loading = ref(false)

  // 計算屬性
  const count = computed(() => items.value.length)

  // 操作
  async function fetchAll() {
    loading.value = true
    try {
      const res = await apiClient.get<{Name}State[]>('/api/{route}')
      items.value = res.data
    } finally {
      loading.value = false
    }
  }

  return {
    items, loading,
    count,
    fetchAll
  }
})
```

重點規則：
- 使用 Composition API 風格（非 Options API）
- `ref()` 管理狀態，`computed()` 衍生屬性
- 非同步操作包含 loading 狀態
- return 物件明確列出所有公開的狀態與方法

---

## 產生流程

當使用者要求產生程式碼時：

1. **確認需求**：功能名稱、欄位、是否需要全部層級
2. **後端**：依序產生 DbModel → DTO → Repository → Service → Endpoint
3. **前端**：依序產生 Service → Store（如需要）→ View / Component
4. **提醒**：DI 註冊、路由註冊、Router 設定

### 命名轉換規則

| 輸入 | 後端類別 | 前端檔案 | 路由 | 資料表 |
|------|---------|---------|------|--------|
| Photo | PhotoEndpoints | photoService.ts | /api/photos | photos |
| BookPage | BookPageEndpoints | bookPageService.ts | /api/book-pages | book_pages |
| UserProfile | UserProfileEndpoints | userProfileService.ts | /api/user-profiles | user_profiles |

- 後端類別：PascalCase
- 前端檔案：camelCase.ts / PascalCase.vue
- API 路由：kebab-case 複數
- 資料表：snake_case 複數
- 資料庫欄位：snake_case
- C# 屬性：PascalCase
- TypeScript 屬性：camelCase
