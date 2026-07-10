# Reference — `decisions-hook` (per-repo PreToolUse guard, v2)

Template hook mà `adk:kickoff` copy vào `<repo-đích>/.claude/settings.json`, sau khi user approve tường minh (DỪNG THẬT). Giảm khả năng sửa nhầm `docs/decisions/` qua các tool chuẩn của Claude Code — **best-effort, không phải security sandbox** (xem "Giới hạn" dưới).

## JSON template

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": {
          "tool": ["Edit", "NotebookEdit"],
          "path": "docs/decisions/**"
        },
        "action": "deny",
        "reason": "adk: docs/decisions/* là append-only — sửa quyết định cũ bằng ADR mới supersede, không Edit trực tiếp."
      },
      {
        "matcher": {
          "tool": "Write",
          "path": "docs/decisions/**",
          "pathExists": true
        },
        "action": "deny",
        "reason": "adk: không ghi đè ADR đã tồn tại — append file mới (NNNN-<slug>.md chưa tồn tại thì Write vẫn cho qua)."
      }
    ]
  }
}
```

- `Edit` / `NotebookEdit` vào bất kỳ file nào khớp `docs/decisions/**` → **deny luôn**, kể cả khi chính `/adk:adr` đang chạy (không có exception theo actor — hook không phân biệt được "ai" đang gọi tool).
- `Write` vào path **đã tồn tại** trong `docs/decisions/**` → **deny** (chặn ghi đè).
- `Write` vào path **chưa tồn tại** khớp `docs/decisions/**` (ví dụ `docs/decisions/0008-slug.md` chưa có) → **không bị chặn** — đây là đường ghi ADR mới hợp lệ duy nhất.

## Cách `adk:kickoff` cài

1. Đọc `<repo-đích>/.claude/settings.json` nếu đã tồn tại — **merge** vào mảng `hooks.PreToolUse` hiện có, không đè mất hook khác của user.
2. Trình nội dung sẽ ghi (diff nếu file đã có, toàn văn nếu file mới) cho user.
3. **DỪNG THẬT** (SPEC v2 §8.2) — chờ approve tường minh.
4. User approve → ghi file. User từ chối → không ghi, kickoff tiếp tục bình thường, chỉ ghi chú vào `CONTEXT.md` rằng hook chưa được cài (để nhắc lại nếu cần).

## Giới hạn (nói rõ, không overclaim)

- **Không phủ Bash/script.** Hook này chỉ chặn `Edit`/`NotebookEdit`/`Write` gọi qua Claude Code tool layer. Một lệnh Bash như `sed -i` hoặc `python -c "open(...).write(...)"` chạy qua công cụ Shell **không bị hook này chặn**.
- **Không phủ chỉnh sửa ngoài Claude Code** (editor khác, git checkout tay, CI job khác).
- **Không phải state machine / sandbox.** adk nhắm mức kỷ luật **workflow discipline ngang Superpowers** — hook giảm thao tác nhầm qua đường thường dùng nhất; an toàn thật nằm ở **`git diff -- docs/decisions/` + review người** trước/sau mỗi lần ghi ADR (xem `adr-protocol` §8).
