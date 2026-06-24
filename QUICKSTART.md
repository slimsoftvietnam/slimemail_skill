# SlimEmail + Claude Code — nhanh nhất

## 1. Cài skill (chọn 1)

**Windows (PowerShell):**
```powershell
git clone https://github.com/slimsoftvietnam/slimemail_skill.git
cd slimemail_skill
.\scripts\install.ps1 -Target "D:\du-an-cua-ban"
```

**Mac/Linux:**
```bash
git clone https://github.com/slimsoftvietnam/slimemail_skill.git
cd slimemail_skill
./scripts/install.sh ~/du-an-cua-ban
```

## 2. Kết nối SlimEmail

Sửa file `.env` trong thư mục dự án:

```env
SLIMEMAIL_API_BASE=https://user.slimemail.vn/api/agent
SLIMEMAIL_API_KEY=<key từ Edit brand → Agent API hoặc Settings → API key>
SLIMEMAIL_BRAND_ID=542
SLIMEMAIL_BRAND_NAME=APLUS
```

Test:
```bash
curl -s "https://user.slimemail.vn/api/agent/me" -H "X-Api-Key: YOUR_KEY"
```

## 3. Prompt Claude Code (copy 1 dòng)

```
Đọc skill slimemail-ai-agent (SKILL.md), dùng SLIMEMAIL_* trong .env, gọi GET /me rồi: [viết yêu cầu — hoặc copy từ USECASES.md]
```

**Ví dụ:**
```
Đọc skill slimemail-ai-agent, GET /me, lấy weekly-report 7 ngày brand APLUS và tóm tắt tiếng Việt.
```

Prompt mẫu khác: [`skills/slimemail-ai-agent/USECASES.md`](skills/slimemail-ai-agent/USECASES.md)
