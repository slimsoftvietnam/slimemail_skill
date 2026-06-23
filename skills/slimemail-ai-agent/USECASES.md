# Use cases — prompt 1 dòng cho Codex

Copy **nguyên dòng prompt** gửi Codex. Agent phải tuân skill `slimemail-ai-agent`: `GET /me` trước, thao tác nguy hiểm cần `dry_run` rồi `confirm`.

**Workflow:** A=khởi động · B=báo cáo · C=subscriber · D=dọn list · E=merge · F=clone · G=campaign · H=admin key

---

## Khởi động & tra cứu (A) · rủi ro thấp

**01 — Kiểm tra kết nối**
```
Qua SlimEmail Agent API: gọi GET /system/health và GET /me, báo mode key, brand_id, cron và capabilities.
```

**02 — Liệt kê brand**
```
Qua SlimEmail Agent API: liệt kê tất cả brand (GET /brands), ghi id, tên, trạng thái; nếu brand key thì chỉ brand hiện tại.
```

**03 — Tổng quan một brand**
```
Qua SlimEmail Agent API: lấy thông tin brand {BRAND_ID}, quota gửi tháng này và danh sách list của brand đó.
```

**04 — Thống kê một list**
```
Qua SlimEmail Agent API: lấy stats list {LIST_ID} — số active, unconfirmed, bounced, unsubscribed.
```

---

## Báo cáo & hiệu quả (B) · rủi ro thấp

**05 — Báo cáo tuần**
```
Qua SlimEmail Agent API: lấy weekly-report 7 ngày, tóm tắt tiếng Việt theo brand — campaign đã gửi, open/click, gợi ý bước tiếp.
```

**06 — Top campaign**
```
Qua SlimEmail Agent API: top 10 campaign 30 ngày qua sort open_rate, bảng tên · open rate · click rate · đã gửi.
```

**07 — Top list**
```
Qua SlimEmail Agent API: top 10 list 30 ngày qua sort open_rate; giải thích nếu list trống do chưa có campaign trong period.
```

**08 — Phân tích sâu campaign**
```
Qua SlimEmail Agent API: deep analytics campaign {CAMPAIGN_ID} — open/click theo link, quốc gia, unsub/bounce.
```

**09 — So sánh campaign**
```
Qua SlimEmail Agent API: so sánh campaign {ID1},{ID2},{ID3} cùng brand — bảng metric và campaign nào hiệu quả hơn.
```

**10 — Overview brand**
```
Qua SlimEmail Agent API: analytics overview brand {BRAND_ID} và performance từng list trong brand.
```

---

## Subscriber (C) · rủi ro trung bình

**11 — Tìm subscriber**
```
Qua SlimEmail Agent API: tìm email "{EMAIL}" trong list {LIST_ID}, trả trạng thái subscription và engagement nếu có.
```

**12 — Thêm subscriber**
```
Qua SlimEmail Agent API: thêm subscriber vào list {LIST_ID}: {EMAIL} (và custom fields nếu có), báo kết quả import.
```

**13 — Xóa subscriber theo email**
```
Qua SlimEmail Agent API: xóa các email sau khỏi list {LIST_ID}: {EMAIL1}, {EMAIL2} — liệt kê trước khi xóa, cần confirm nếu API yêu cầu.
```

**14 — Chuyển subscriber giữa list**
```
Qua SlimEmail Agent API: chuyển (move) email {EMAIL} từ list {FROM_LIST_ID} sang list {TO_LIST_ID}, báo số lượng thành công/lỗi.
```

**15 — Import từ campaign**
```
Qua SlimEmail Agent API: import subscriber segment "{opened|clicked|unopened}" từ campaign {CAMPAIGN_ID} vào list {LIST_ID}.
```

---

## Dọn list (D) · rủi ro cao — bắt buộc dry_run

**16 — Tóm tắt cần dọn**
```
Qua SlimEmail Agent API: housekeeping summary brand {BRAND_ID} — list nào có nhiều inactive/unconfirmed/bounced.
```

**17 — Xem inactive trước khi xóa**
```
Qua SlimEmail Agent API: liệt kê subscriber inactive list {LIST_ID}, type not_opened, 90 ngày — trang 1, tổng ước lượng.
```

**18 — Dọn không mở mail**
```
Qua SlimEmail Agent API: list {LIST_ID} xóa subscriber not_opened 90 ngày — dry_run trước, báo would_delete, chỉ confirm khi tôi đồng ý.
```

**19 — Dọn bounced / unconfirmed**
```
Qua SlimEmail Agent API: list {LIST_ID} xóa bounced và unconfirmed — dry_run từng loại, tóm tắt số lượng trước khi confirm.
```

---

## Gom & clone list (E, F) · rủi ro cao · cross-brand cần global key

**20 — Gom nhiều list**
```
Qua SlimEmail Agent API: merge list {SOURCE_IDS} vào list đích {TARGET_LIST_ID}, active_only, skip duplicate — dry_run rồi báo estimated_imported.
```

**21 — Clone list sang brand khác**
```
Qua SlimEmail Agent API: clone list {SOURCE_LIST_ID} sang brand {TARGET_BRAND_ID}, tên "{NEW_NAME}", active_only — dry_run trước, confirm khi tôi OK.
```

---

## Campaign (G) · rủi ro rất cao — quota + dry_run + confirm

**22 — Draft campaign mới**
```
Qua SlimEmail Agent API: tạo campaign draft brand {BRAND_ID} — subject "{SUBJECT}", from name/email theo brand, chưa gửi.
```

**23 — Gửi campaign**
```
Qua SlimEmail Agent API: gửi campaign {CAMPAIGN_ID} tới list {LIST_IDS} — kiểm tra quota, dry_run recipients, chỉ confirm gửi thật khi tôi đồng ý.
```

**24 — Lên lịch gửi**
```
Qua SlimEmail Agent API: schedule campaign {CAMPAIGN_ID} lúc {DATETIME} timezone Asia/Ho_Chi_Minh tới list {LIST_IDS} — dry_run rồi confirm.
```

**25 — Tiến độ đang gửi**
```
Qua SlimEmail Agent API: progress campaign {CAMPAIGN_ID} đang gửi — % hoàn thành, recipients sent/remaining.
```

**26 — Gợi ý audience**
```
Qua SlimEmail Agent API: recommend audience brand {BRAND_ID} cho campaign sắp gửi — list/segment phù hợp dựa trên lịch sử mở/click.
```

---

## Admin & phụ trợ · rủi ro tùy thao tác

**27 — Kiểm tra API key brand**
```
Qua SlimEmail Agent API (global key): trạng thái agent key brand {BRAND_ID} — đã có key chưa, không hiển thị full key.
```

**28 — Tạo lại brand key**
```
Qua SlimEmail Agent API (global key): regenerate agent key brand {BRAND_ID} với confirm true — chỉ khi tôi yêu cầu rõ.
```

**29 — Suppression list**
```
Qua SlimEmail Agent API: liệt kê suppression brand {BRAND_ID} và thêm email {EMAIL} vào suppression nếu tôi xác nhận.
```

**30 — Templates & segments**
```
Qua SlimEmail Agent API: liệt kê templates và segments brand {BRAND_ID}, ghi id và tên để chọn cho campaign tiếp theo.
```

---

## Ghi chú thay placeholder

| Placeholder | Thay bằng |
|-------------|-----------|
| `{BRAND_ID}` | id brand, vd. 542 (APLUS) |
| `{LIST_ID}` | id list |
| `{CAMPAIGN_ID}` | id campaign |
| `{EMAIL}` | địa chỉ email |
| `{SUBJECT}` | tiêu đề mail |
| `{DATETIME}` | ISO hoặc `2026-06-24 09:00` |
