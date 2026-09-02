#!/usr/bin/env bash
# Sinh ~/.codex/AGENTS.md từ nguồn canonical ~/.claude/CLAUDE.md + rules/core/,
# nối thêm phần Codex-only ở templates/codex-extra.md.
# Chạy lại mỗi khi rules đổi. KHÔNG sửa tay file đích — mọi sửa sẽ bị ghi đè;
# nội dung riêng cho Codex phải nằm ở templates/codex-extra.md (được git track).
set -eu
SRC="$HOME/.claude"
OUT="$HOME/.codex/AGENTS.md"
EXTRA="$SRC/templates/codex-extra.md"
[ -f "$EXTRA" ] || { echo "❌ thiếu $EXTRA — dừng để không mất phần Codex-only" >&2; exit 1; }
mkdir -p "$(dirname "$OUT")"
tmp_out=$(mktemp "${OUT}.tmp.XXXXXX")
cleanup() { rm -f "$tmp_out"; }
trap cleanup EXIT

{
  echo "<!-- SINH TỰ ĐỘNG bởi ~/.claude/scripts/render-agent-rules.sh — KHÔNG sửa tay. -->"
  echo "<!-- Nguồn: ~/.claude/CLAUDE.md + rules/core/*.md + templates/codex-extra.md -->"
  echo
  echo "> **Giới hạn nền tảng:** Codex nhận lớp VĂN BẢN. Hook \`file-guard.sh\` của Claude Code"
  echo "> không chạy ở đây. Tuân D-rules bên dưới bằng kỷ luật, không trông vào cưỡng chế."
  echo
  cat "$SRC/CLAUDE.md"
  for f in "$SRC"/rules/core/*.md; do echo; echo "---"; echo; cat "$f"; done
  echo; echo "---"; echo
  cat "$EXTRA"
} > "$tmp_out"

chmod 0644 "$tmp_out"
mv "$tmp_out" "$OUT"
trap - EXIT

echo "✅ đã sinh $OUT ($(wc -l < "$OUT" | tr -d ' ') dòng)"
