#!/usr/bin/env bash
# docs-compliance.sh <doc-root> — repo có đủ tài liệu bắt buộc và đúng dạng không (D5).
# KHÁC docs-anchors.sh: script kia hỏi "anchor còn sống không", script này hỏi "có đủ không".
# Từ 2026-09-07 (MXR-37/38): D5 chỉ còn cặp AGENTS.md + CLAUDE.md; docs/ARCHITECTURE.md,
# docs/CONTEXT.md và mục "Chưa khớp thực tế" (D7 cũ) không còn bắt buộc — trạng thái đang
# làm sống trong issue Linear. Nhãn ý định (D6 cũ) đã bỏ 2026-09-09 cùng MXR-36: nhãn
# đánh dấu trạng thái của spec/CONTEXT, và bộ đó không còn nằm trong repo.
set -u
root="${1:-$PWD}"; root="${root%/}"
[ -d "$root" ] || { echo "docs-compliance: không có thư mục '$root'" >&2; exit 2; }
bad=0
say() { echo "❌ $1"; bad=1; }

# --- D5: áp cho MỌI repo, kể cả repo có PIPELINE.lock (D2 không miễn D5) ---
[ -f "$root/AGENTS.md" ] || say "thiếu AGENTS.md (D5)"
if [ -f "$root/CLAUDE.md" ]; then
  grep -qxF '@AGENTS.md' "$root/CLAUDE.md" \
    || say "CLAUDE.md không có dòng '@AGENTS.md' — Claude Code sẽ không đọc AGENTS.md (D5)"
else
  say "thiếu CLAUDE.md — cần dòng đầu '@AGENTS.md' (D5)"
fi

# --- D3/D4: docs/ chỉ có ba tầng + README.md + DESIGN-LANGUAGE.md; thư mục việc-đang-làm là legacy ---
# Chỉ cảnh báo (không đổi exit): repo dọn dần theo issue riêng (Deck: MXR-36).
if [ -d "$root/docs" ] && [ ! -f "$root/PIPELINE.lock" ]; then
  for d in specs plans review superpowers intent decisions daily archive mockups; do
    [ -d "$root/docs/$d" ] && echo "⚠️ docs/$d/ còn tồn tại — spec/plan/review là issue Linear, thư mục này chờ dọn (D3/D4)"
  done
fi

[ $bad -eq 0 ] && echo "✅ $root tuân thủ D5"
exit $bad
