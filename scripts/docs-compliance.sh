#!/usr/bin/env bash
# docs-compliance.sh <doc-root> — repo có đủ tài liệu bắt buộc và đúng dạng không (D5/D6).
# KHÁC docs-anchors.sh: script kia hỏi "anchor còn sống không", script này hỏi "có đủ không".
# Từ 2026-09-07 (MXR-37/38): D5 chỉ còn cặp AGENTS.md + CLAUDE.md; docs/ARCHITECTURE.md,
# docs/CONTEXT.md và mục "Chưa khớp thực tế" (D7 cũ) không còn bắt buộc — trạng thái đang
# làm sống trong issue Linear. D6 (nhãn ý định) chỉ áp cho tài liệu sống ở gốc repo.
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

# --- D6: miễn cho repo dùng pipeline riêng (D2) ---
if [ ! -f "$root/PIPELINE.lock" ]; then
  living=()
  for f in AGENTS.md README.md CHANGELOG.md; do [ -f "$root/$f" ] && living+=("$root/$f"); done
  for doc in "${living[@]:-}"; do
    [ -n "${doc:-}" ] || continue
    rel="${doc#"$root"/}"
    while IFS= read -r hit; do
      lineno="${hit%%:*}"; line="${hit#*:}"
      case "$line" in *'](http'*|*'](#'*|*'](mailto:'*) continue ;; esac
      next_line=$(sed -n "$((lineno + 1))p" "$doc")
      printf '%s %s' "$line" "$next_line" \
        | grep -Eq '\)[[:space:]]*`(current|decided|building|deprecated)`' \
        || say "$rel:$lineno link thiếu nhãn ý định current/decided/building/deprecated (D6)"
    done < <(grep -nE '\[[^]]*\]\([^)]+\)' "$doc" 2>/dev/null || true)
  done
fi

[ $bad -eq 0 ] && echo "✅ $root tuân thủ D5/D6"
exit $bad
