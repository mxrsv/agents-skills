---
name: log-wiki
description: Capture knowledge vào Tolaria wiki từ mốc lastLoggedAt — cook gợi nhớ (Claude/Codex/Cursor + git), hỏi người kể, soạn entry, xin duyệt rồi ghi qua record-capture.js. Dùng khi người dùng nói "log-wiki", "ghi wiki", "capture wiki", "tổng kết knowledge wiki", hoặc gọi /log-wiki.
---

# Log wiki — capture knowledge vào vault

Đây là quy trình CÓ NGƯỜI Ở GIỮA, không phải script chạy một phát ra kết quả.
**Máy KHÔNG tự sinh bài học / knowledge rồi ghi.** Gợi nhớ chỉ là gợi nhớ —
nội dung entry PHẢI do người viết kể; agent chỉ soạn lại lời kể đó; người viết
PHẢI duyệt trước khi bất kỳ thứ gì được ghi vào vault.

Bổ sung chứ không thay `/activity` (log-day): `/activity` = bài học cách làm việc;
`log-wiki` = knowledge vault (fact, quyết định, chỗ note sai/thiếu, câu hỏi mở).

## Cảnh báo cứng

- Collect rỗng/mỏng **≠** hết chuyện để kể — vẫn hỏi người viết.
- **Không** dùng `/insights` hay `usage-data` (đã đóng băng).
- Bổ sung `/activity`, không thay thế; đừng hỏi lại góc "loay hoay hôm nay" kiểu log-day.
- **Không** tự patch note Tolaria đích — chỉ đề xuất `[[note]]`; sau duyệt thì
  `record-capture.js` append note tháng + cập nhật `lastLoggedAt`.
- **Không** dump secret, prompt đầy đủ, stdout tool, hay nội dung transcript nhạy cảm.

## Codex / Cursor

- Skill này sống ở `~/.claude/skills/log-wiki/` (Claude Code + Cursor nếu nạp skill
  thư mục đó).
- `~/.codex/AGENTS.md` là file sinh tự động — đừng sửa tay. Nudge Codex đi qua
  `~/.claude/CLAUDE.md` / `~/.claude/templates/codex-extra.md` rồi chạy
  `~/.claude/scripts/render-agent-rules.sh` khi muốn đồng bộ. Nếu chưa sync:
  dựa vào Cursor Automation (nhắc gap) + gọi tay `/log-wiki` / skill này.

## Bước 1 — Resolve vault

1. Nếu có biến môi trường `WIKI_VAULT` và là đường dẫn absolute tồn tại → dùng.
2. Không thì fallback:
   `/Users/kyantran/Documents/Development/Vault/mxrsv-wiki`
   và **cảnh báo** đang dùng fallback.
3. Mọi lệnh `node scripts/log-wiki/...` chạy từ gốc vault đó.

## Bước 2 — Đọc mốc `lastLoggedAt`

Đọc frontmatter `wiki-capture-state.md` tại gốc vault.

- Có `lastLoggedAt` dạng local `YYYY-MM-DD` → đó là `from` (đầu ngày local →
  bound datetime khi collect; script lo phần convert nếu đã implement).
- **Thiếu** → hỏi người viết mốc khởi tạo một lần (ví dụ hôm nay, hoặc ngày bắt
  đầu muốn capture). Không suy `from` chỉ từ `git log` note.

## Bước 3 — Cook gợi nhớ

```bash
node scripts/log-wiki/collect.js --from=<ISO-or-date> [--to=<ISO>] [--repo=<path>]*
```

- Khoảng nửa mở `[from, to)`; mặc định `to` = now nếu script hỗ trợ.
- Output stdout JSON: `from`, `to`, `sessions[]`, `repos[]`, `gitByRepo`, `coverage`.
- **Không** in / không dán nguyên JSON có thể chứa prompt nhạy cảm vào chat dài.
  Chỉ tóm tắt cấu trúc: coverage theo source, số orphan, vài repo + git headline.

## Step 4 — Explain in the active Output Style's language, then ASK

Tóm tắt ngắn (vài câu): khoảng thời gian, phiên Claude/Codex/Cursor (đếm),
repo + commit đáng chú ý. Nhắc nếu collect mỏng/rỗng.

Rồi hỏi góc **knowledge wiki**, kiểu:

> "Từ lần capture trước tới giờ, có knowledge nào đáng ghi vào wiki không —
> fact mới, quyết định, chỗ note đang sai/thiếu, câu hỏi còn mở?"

**Chờ người viết trả lời.** Không tự bịa bài học từ transcript.

## Bước 5 — Soạn bản nháp

Từ lời kể (bổ sung chi tiết cụ thể từ gợi nhớ nếu người nhắc chung chung), soạn:

- **headline**: one sentence for the capture period, in the active Output Style's language.
- **3–8 bullets** in the active Output Style's language.
- **Đề xuất** `[[note]]` liên quan (nếu có) — chỉ gợi ý, không sửa file đó.

Hiện bản nháp cho người viết đọc. **Không ghi file ở bước này.**

## Bước 6 — Xin duyệt rõ

Hỏi: "Ghi vậy được không, hay sửa gì?" Chỉ đi tiếp khi xác nhận rõ
(kiểu "được", "ghi đi", "ok").

## Bước 7 — Ghi qua `record-capture.js`

Pipe JSON đúng khuôn mà script expect (xem usage / test của
`scripts/log-wiki/record-capture.js`) — tối thiểu khoảng thời gian, headline,
bullets, suggestions. Ví dụ tinh thần:

```bash
echo '<JSON>' | node scripts/log-wiki/record-capture.js
```

- Skill **không** Edit tay `lastLoggedAt` hay append tháng bằng tay.
- Script append `wiki-capture-YYYY-MM.md` + cập nhật state.

Báo lại file đã đụng và `lastLoggedAt` mới khi script thành công.

## Lỗi / tình huống thường gặp

- Thiếu `collect.js` / `record-capture.js` → dừng, nói scripts chưa có (agent khác
  đang làm); vẫn có thể hỏi người kể và giữ bản nháp chờ.
- `lastLoggedAt` thiếu → hỏi mốc khởi tạo, không đoán thầm.
- Collect rỗng → vẫn hỏi; trí nhớ người viết là nguồn sự thật của entry.
