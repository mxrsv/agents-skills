#!/usr/bin/env bash
# docs-compliance.sh <doc-root> — repo có đủ tài liệu bắt buộc và đúng dạng không (D5/D6/D7).
# KHÁC docs-anchors.sh: script kia hỏi "anchor còn sống không", script này hỏi "có đủ không".
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
[ -f "$root/docs/ARCHITECTURE.md" ] || say "thiếu docs/ARCHITECTURE.md (D5)"
[ -f "$root/docs/CONTEXT.md" ] || say "thiếu docs/CONTEXT.md (D5)"

# --- D6/D7: miễn cho repo dùng pipeline riêng (D2) ---
if [ ! -f "$root/PIPELINE.lock" ]; then
  living=()
  for f in AGENTS.md README.md CHANGELOG.md; do [ -f "$root/$f" ] && living+=("$root/$f"); done
  if [ -d "$root/docs" ]; then
    while IFS= read -r f; do living+=("$f"); done < <(
      find "$root/docs" -maxdepth 1 -type f -name '*.md' | grep -E '/[A-Z0-9][A-Z0-9_-]*\.md$' | sort)
  fi
  for doc in "${living[@]:-}"; do
    [ -n "${doc:-}" ] || continue
    rel="${doc#"$root"/}"
    grep -qF '## Chưa khớp thực tế' "$doc" || say "$rel thiếu mục '## Chưa khớp thực tế' (D7)"
    while IFS= read -r hit; do
      lineno="${hit%%:*}"; line="${hit#*:}"
      case "$line" in *'](http'*|*'](#'*|*'](mailto:'*) continue ;; esac
      printf '%s' "$line" | grep -Eq '\)[[:space:]]*`(current|decided|building|deprecated)`' \
        || say "$rel:$lineno link thiếu nhãn ý định current/decided/building/deprecated (D6)"
    done < <(grep -nE '\[[^]]*\]\([^)]+\)' "$doc" 2>/dev/null || true)
  done
fi

[ $bad -eq 0 ] && echo "✅ $root tuân thủ D5/D6/D7"
exit $bad
