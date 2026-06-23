# SlimEmail Skill — Agent API

Repo **public** chứa **skill** để agent (Cursor, Codex, …) điều khiển [SlimEmail](https://user.slimemail.vn) qua **Agent REST API**.

**Không** chứa mã nguồn Sendy/SlimEmail — phần ứng dụng nằm repo riêng (private).

## Cấu trúc

```
slimemail_skill/
├── skills/slimemail-ai-agent/   # SKILL.md + USECASES.md (30 prompt Codex)
├── rules/                       # Cursor rule (tùy chọn)
├── docs/openapi.yaml            # OpenAPI spec Agent API
└── .env.example                 # Biến môi trường mẫu
```

## Cài đặt nhanh (Cursor)

1. Clone repo:

```bash
git clone https://github.com/slimsoftvietnam/slimemail_skill.git
```

2. Copy skill vào project hoặc thư mục skills của Cursor:

```bash
# Trong repo SlimEmail / workspace
cp -r slimemail_skill/skills/slimemail-ai-agent .cursor/skills/
cp slimemail_skill/rules/slimemail-ai-agent.mdc .cursor/rules/
```

3. Copy `.env.example` → `.env` và điền key (không commit):

```env
SLIMEMAIL_API_BASE=https://user.slimemail.vn/api/agent
SLIMEMAIL_API_KEY=<brand_or_global_key>
SLIMEMAIL_BRAND_ID=
SLIMEMAIL_BRAND_NAME=
```

## Agent API

| | |
|---|---|
| Base URL | `https://user.slimemail.vn/api/agent` |
| Auth | `Authorization: Bearer <API_KEY>` hoặc `X-Api-Key` |
| Global key | Settings → API key (mọi brand) |
| Brand key | Edit brand → Agent API (một brand) |

**Luôn gọi trước mỗi phiên:**

```http
GET /system/health
GET /me
```

Thao tác xóa / gửi / merge: `dry_run: true` → review → `confirm: true`.

Chi tiết endpoint: [`docs/openapi.yaml`](docs/openapi.yaml) · skill [`SKILL.md`](skills/slimemail-ai-agent/SKILL.md) · **30 prompt Codex:** [`USECASES.md`](skills/slimemail-ai-agent/USECASES.md).

### Nginx (user.slimemail.vn)

Host production dùng **Nginx** — rule `.htaccess` không áp dụng. Thêm rewrite từ [`docs/nginx-agent-api.conf`](docs/nginx-agent-api.conf):

```nginx
location ^~ /api/agent {
    rewrite ^/api/agent/?(.*)$ /api/agent/index.php?route=$1 last;
}
```

Workaround trước khi sửa nginx:

```
GET /api/agent/index.php?route=me
GET /api/agent/index.php?route=system/health
```

## Kiểm tra kết nối

```bash
curl -s "https://user.slimemail.vn/api/agent/me" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Accept: application/json"
```

## License

Skill và tài liệu API — SlimSoft Vietnam. SlimEmail/Sendy là sản phẩm riêng của tổ chức bạn.
