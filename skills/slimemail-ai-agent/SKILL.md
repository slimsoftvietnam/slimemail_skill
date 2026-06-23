---
name: slimemail-ai-agent
description: |
  Điều khiển SlimEmail (Sendy multi-brand) qua Agent REST API trên user.slimemail.vn.
  Dùng khi user hỏi về email marketing, brand, list, subscriber, campaign, báo cáo,
  dọn list, merge list, gửi newsletter, Agent API, hoặc Codex thao tác SlimEmail.
---

# SlimEmail AI Agent

Bạn vận hành **SlimEmail** qua **Agent API** — không sửa DB trực tiếp, không thay thế cron gửi mail.

Tài liệu chi tiết: [`docs/openapi.yaml`](../../docs/openapi.yaml) (repo [slimemail_skill](https://github.com/slimsoftvietnam/slimemail_skill)).

## Kết nối

| | Production | Local dev |
|---|------------|-----------|
| Base URL | `https://user.slimemail.vn/api/agent` | `http://localhost/slimemail/api/agent` |

**Headers mọi request:**

```http
Authorization: Bearer <API_KEY>
Accept: application/json
Content-Type: application/json   # POST/PATCH/PUT
```

Hoặc: `X-Api-Key: <API_KEY>` thay cho Authorization.

**Biến môi trường (ưu tiên):**

```env
SLIMEMAIL_API_BASE=https://user.slimemail.vn/api/agent
SLIMEMAIL_API_KEY=<brand_or_global_key>
SLIMEMAIL_BRAND_ID=542
SLIMEMAIL_BRAND_NAME=APLUS
```

Không commit API key vào git.

## Hai chế độ key

| | Global | Brand-scoped |
|---|--------|----------------|
| Nguồn | Settings → API key (`login.api_key`) | Edit brand → Agent API (`apps.agent_api_key`) |
| Phạm vi | Mọi brand | Một brand cố định |
| Cross-brand clone/merge | Có | Không |
| Tạo/xóa brand | Có | Không |
| Regenerate brand key | Có (global) | Không |

**Luôn bước đầu mỗi phiên:**

```http
GET /system/health
GET /me
```

Đọc `data.auth.mode` (`global` | `brand`), `data.auth.brand_id`, `data.auth.capabilities`.

## Response

```json
{ "success": true, "data": { }, "meta": { "timestamp": "..." } }
{ "success": false, "error": { "code": "...", "message": "..." } }
```

## Quy tắc bắt buộc

1. **Đọc trước ghi** — analytics, inactive, quota: GET trước POST/DELETE.
2. **Dry run** — housekeeping, merge, clone, send: `"dry_run": true` trước.
3. **`confirm: true`** — chỉ sau khi user/agent review số liệu dry run (`would_delete`, `estimated_imported`, …).
4. **Brand key** — không thao tác brand khác; URL có `{brand_id}` vẫn bị server chặn nếu sai scope.
5. **Gửi thật** — `POST /campaigns/{id}/send` / `schedule` cần cron `scheduled.php` trên server Sendy.
6. **Rate limit** — ~300 req/phút; 30 send/schedule/giờ/brand; 10 clone/merge/giờ.

## Workflow A — Khởi động

```
GET /me
GET /brands                         # global
GET /brands/{brand_id}              # một brand
GET /brands/{brand_id}/quota
GET /brands/{brand_id}/lists
```

## Workflow B — Báo cáo & hiệu quả

```
GET /analytics/weekly-report?days=7
GET /analytics/top-campaigns?days=7&limit=10&sort=open_rate
GET /analytics/top-lists?days=30&limit=10&sort=open_rate
GET /brands/{brand_id}/analytics/lists
GET /campaigns/{id}/analytics/deep
```

Brand active trên UI (`app_name NOT LIKE '(close)%'`) khác với có campaign trong khoảng `days` — nếu `lists: []` báo user thiếu dữ liệu gửi trong period.

## Workflow C — Subscribers

```
GET /lists/{list_id}/subscribers?page=1&per_page=50
POST /lists/{list_id}/subscribers    body: { subscribers: [...] }
DELETE /lists/{list_id}/subscribers  body: { emails: [...] }
POST /subscribers/move               body: { from_list_id, to_list_id, emails, mode: move|copy }
```

## Workflow D — Dọn list (inactive)

```
GET /brands/{brand_id}/housekeeping/summary
GET /lists/{list_id}/subscribers/inactive?type=not_opened&days=90&page=1
POST /lists/{list_id}/housekeeping
  { "action": "delete_inactive", "type": "not_opened", "days": 90, "dry_run": true }
POST /lists/{list_id}/housekeeping
  { ..., "confirm": true }
```

| type | Ý nghĩa |
|------|---------|
| `not_opened` | Confirm, không mở campaign trong N ngày |
| `stale` | Join trước N ngày, vẫn active |
| `unconfirmed` | Chưa opt-in |
| `bounced` / `unsubscribed` / `complained` | Theo tên |

Actions khác: `delete_unconfirmed_all`, `delete_bounced`, `delete_unsubscribed`, …

## Workflow E — Gom list (merge)

```
POST /lists/merge
{
  "target_list_id": 100,
  "source_list_ids": [45, 46],
  "options": { "subscriber_filter": "active_only", "skip_duplicates_in_target": true },
  "dry_run": true
}
→ review estimated_imported → "confirm": true
```

Cross-brand: **global key only**. List nguồn không bị xóa sau merge.

## Workflow F — Clone list

```
POST /lists/clone/preview   # optional
POST /lists/clone
{
  "source_list_id": 45,
  "target_brand_id": 20,
  "new_list_name": "...",
  "options": { "subscriber_filter": "active_only", "target_list_id": 99 },
  "dry_run": true
}
→ "confirm": true
```

Cross-brand: global key.

## Workflow G — Campaign

```
GET /brands/{brand_id}/campaigns?status=sent|draft|scheduled
POST /brands/{brand_id}/campaigns
PATCH /campaigns/{id}
POST /campaigns/{id}/send
  { "list_ids": [1,2], "dry_run": true }
  { "list_ids": [1,2], "confirm": true }
POST /campaigns/{id}/schedule
  { "send_at": "...", "timezone": "Asia/Ho_Chi_Minh", "confirm": true }
GET /tasks/{job_id}
```

## Workflow H — Brand agent key (global only)

```
GET /brands/{id}/agent-key
POST /brands/{id}/agent-key/regenerate
  { "confirm": true }
```

## Endpoint map (tóm tắt)

| Nhóm | Path |
|------|------|
| System | `/me`, `/system/health`, `/auth/verify` |
| Brands | `/brands`, `/brands/{id}`, `/brands/{id}/quota` |
| Lists | `/brands/{id}/lists`, `/lists/{id}`, `/lists/merge`, `/lists/clone` |
| Subscribers | `/lists/{id}/subscribers`, `/lists/{id}/subscribers/inactive` |
| Housekeeping | `/brands/{id}/housekeeping/summary`, `/lists/{id}/housekeeping` |
| Campaigns | `/brands/{id}/campaigns`, `/campaigns/{id}/send`, `/schedule` |
| Analytics | `/analytics/weekly-report`, `/top-campaigns`, `/top-lists` |
| Templates/Segments | `/brands/{id}/templates`, `/brands/{id}/segments` |

## Lỗi thường gặp

| | Xử lý |
|---|--------|
| 401 | Sai key hoặc sai base URL |
| 403 scope | Brand key + brand khác → dùng global hoặc đúng brand |
| 403 QUOTA_EXCEEDED | Dừng gửi, báo user |
| CONFIRMATION_REQUIRED | dry_run trước, rồi confirm |
| 404 | Thiếu nginx/apache rewrite `/api/agent` |

## Phong cách

- Trả lời **tiếng Việt** (trừ thuật ngữ API).
- Ghi rõ method + path + body khi đề xuất thao tác.
- Xóa / gửi / merge: **bắt buộc** nêu số liệu dry run trước confirm.
- Ưu tiên `GET /analytics/weekly-report` khi user hỏi "tuần này / tháng này / hiệu quả".
