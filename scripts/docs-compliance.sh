#!/usr/bin/env bash
# docs-compliance.sh <doc-root> — repo có đủ tài liệu bắt buộc và đúng dạng không (D5).
# KHÁC docs-anchors.sh: script kia hỏi "anchor còn sống không", script này hỏi "có đủ không".
# Từ 2026-09-07 (MXR-37/38): D5 chỉ còn AGENTS.md (CLAUDE.md tuỳ chọn từ 2026-09-29); docs/ARCHITECTURE.md,
# docs/CONTEXT.md và mục "Chưa khớp thực tế" (D7 cũ) không còn bắt buộc — trạng thái đang
# Since 2026-10-03: requirements live in docs/specs/; execution and progress in docs/plans/.
# Specs and plans are design/execution records, not living docs; reviews default to chat.
set -u
root="${1:-$PWD}"; root="${root%/}"
[ -d "$root" ] || { echo "docs-compliance: không có thư mục '$root'" >&2; exit 2; }
bad=0
say() { echo "❌ $1"; bad=1; }

# --- D5: áp cho MỌI repo, kể cả repo có PIPELINE.lock (D2 không miễn D5) ---
[ -f "$root/AGENTS.md" ] || say "thiếu AGENTS.md (D5)"
# CLAUDE.md là tuỳ chọn (Claude Code v2.1.277+ đọc thẳng AGENTS.md); nếu có mà không import thì AGENTS.md bị che.
if [ -f "$root/CLAUDE.md" ] && ! grep -qxF '@AGENTS.md' "$root/CLAUDE.md"; then
  echo "⚠️ CLAUDE.md không có dòng '@AGENTS.md' — Claude Code sẽ bỏ qua AGENTS.md (D5)"
fi

# D3/D4: three living tiers plus specs/ and plans/; other retired directories remain legacy.
# Chỉ cảnh báo (không đổi exit): repo dọn dần theo issue riêng (Deck: MXR-36).
if [ -d "$root/docs" ] && [ ! -f "$root/PIPELINE.lock" ]; then
  for d in review superpowers intent decisions daily archive mockups; do
    [ -d "$root/docs/$d" ] && echo "⚠️ docs/$d/ còn tồn tại — retired directory; requirements belong in docs/specs/, implementation in docs/plans/, reviews in chat or a requested PR (D3/D4)"
  done
fi

[ $bad -eq 0 ] && echo "✅ $root tuân thủ D5"
exit $bad
