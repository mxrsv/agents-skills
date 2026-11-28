#!/usr/bin/env bash
# docs-compliance.sh <doc-root> — repo có đủ tài liệu bắt buộc và đúng dạng không (luật AGENTS.md).
# KHÁC docs-anchors.sh: script kia hỏi "anchor còn sống không", script này hỏi "có đủ không".
# Từ 2026-09-07 (MXR-37/38): chỉ còn bắt buộc AGENTS.md (CLAUDE.md tuỳ chọn từ 2026-09-29); docs/ARCHITECTURE.md,
# docs/CONTEXT.md và mục "Chưa khớp thực tế" cũ không còn bắt buộc — trạng thái đang
# Since 2026-10-03: requirements live in docs/specs/. Since 2026-11-28: no plan files; status lives in the spec.
# Specs and legacy plans are records, not living docs; reviews default to chat.
set -u
root="${1:-$PWD}"; root="${root%/}"
[ -d "$root" ] || { echo "docs-compliance: không có thư mục '$root'" >&2; exit 2; }
bad=0
say() { echo "❌ $1"; bad=1; }

# --- AGENTS.md: áp cho MỌI repo, kể cả repo có PIPELINE.lock (pipeline không miễn luật này) ---
# ~/.claude: CLAUDE.md là file hướng dẫn toàn cục; Claude Code bỏ qua AGENTS.md ở đó, nên không đòi AGENTS.md.
is_user_dir=0
if [ -d "$HOME/.claude" ] && [ "$(cd "$root" && pwd -P)" = "$(cd "$HOME/.claude" && pwd -P)" ] && [ -f "$root/CLAUDE.md" ]; then
  is_user_dir=1
fi
[ -f "$root/AGENTS.md" ] || [ $is_user_dir -eq 1 ] || say "thiếu AGENTS.md"
# CLAUDE.md là tuỳ chọn (Claude Code v2.1.277+ đọc thẳng AGENTS.md); nếu có mà không import thì AGENTS.md bị che.
if [ $is_user_dir -eq 0 ] && [ -f "$root/CLAUDE.md" ] && ! grep -qxF '@AGENTS.md' "$root/CLAUDE.md"; then
  echo "⚠️ CLAUDE.md không có dòng '@AGENTS.md' — Claude Code sẽ bỏ qua AGENTS.md"
fi

# docs/ layout: three living tiers plus specs/ (plans/ legacy); other retired directories remain legacy.
# Chỉ cảnh báo (không đổi exit): repo dọn dần theo issue riêng (Deck: MXR-36).
if [ -d "$root/docs" ] && [ ! -f "$root/PIPELINE.lock" ]; then
  for d in review superpowers intent decisions daily archive mockups; do
    [ -d "$root/docs/$d" ] && echo "⚠️ docs/$d/ còn tồn tại — retired directory; requirements and status belong in docs/specs/, reviews in chat or a requested PR"
  done
fi

[ $bad -eq 0 ] && echo "✅ $root đủ file hướng dẫn"
exit $bad
