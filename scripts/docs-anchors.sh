#!/usr/bin/env bash
# docs-anchors.sh <doc-root> — kiểm anchor chết trong TÀI LIỆU SỐNG (D6).
# Chỉ xét markdown link tường minh; mọi inline code khác KHÔNG phải anchor.
# Path trong link tính tương đối từ CHÍNH FILE chứa link (ngữ nghĩa markdown chuẩn).
set -u
root="${1:-$PWD}"; root="${root%/}"
[ -d "$root" ] || { echo "docs-anchors: không có thư mục '$root'" >&2; exit 2; }
problems=0

living=()
for f in AGENTS.md README.md CHANGELOG.md; do [ -f "$root/$f" ] && living+=("$root/$f"); done
if [ -d "$root/docs" ]; then
  while IFS= read -r f; do living+=("$f"); done < <(
    find "$root/docs" -maxdepth 1 -type f -name '*.md' | grep -E '/[A-Z0-9][A-Z0-9_-]*\.md$' | sort)
fi
[ ${#living[@]} -eq 0 ] && exit 0

for doc in "${living[@]}"; do
  rel_doc="${doc#"$root"/}"
  docdir=$(dirname "$doc")
  while IFS= read -r hit; do
    lineno="${hit%%:*}"; link="${hit#*:}"
    target=$(printf '%s' "$link" | sed -E 's/^\[[^]]*\]\((.*)\)$/\1/')
    case "$target" in http://*|https://*|mailto:*|'#'*|'') continue ;; esac
    path="${target%%#*}"; frag="${target#"$path"}"; frag="${frag#\#}"
    abs="$docdir/$path"                      # ← file-relative, KHÔNG phải $root/$path
    if [ ! -e "$abs" ]; then
      echo "❌ $rel_doc:$lineno  [$path] — file không tồn tại"; problems=$((problems+1)); continue
    fi
    [ -z "$frag" ] && continue
    if printf '%s' "$frag" | grep -Eq '^L[0-9]+(-L[0-9]+)?$'; then
      total=$(wc -l < "$abs" | tr -d ' ')
      n=$(printf '%s' "$frag" | sed -E 's/^L([0-9]+).*/\1/')
      m=$(printf '%s' "$frag" | sed -nE 's/^L[0-9]+-L([0-9]+)$/\1/p')
      if [ "$n" -gt "$total" ] || { [ -n "$m" ] && [ "$m" -gt "$total" ]; }; then
        echo "❌ $rel_doc:$lineno  [$path#$frag] — file chỉ có $total dòng"; problems=$((problems+1))
      fi
    else
      # -F fixed-string: symbol chứa [ ] * $ không bị hiểu thành regex
      grep -qF -- "$frag" "$abs" || {
        echo "❌ $rel_doc:$lineno  [$path#$frag] — symbol không có trong file"; problems=$((problems+1)); }
    fi
  done < <(grep -noE '\[[^]]*\]\([^)]+\)' "$doc" 2>/dev/null || true)
done

# Lệnh trong AGENTS.md đối chiếu package.json
if [ -f "$root/AGENTS.md" ] && [ -f "$root/package.json" ]; then
  while IFS= read -r cmd; do
    script="${cmd##* }"
    jq -e --arg s "$script" '.scripts | has($s)' "$root/package.json" >/dev/null 2>&1 \
      || { echo "⚠️ AGENTS.md — lệnh \`$cmd\`: không có script '$script' trong package.json"; problems=$((problems+1)); }
  done < <(grep -oE '`(pnpm|npm|yarn|bun) [a-z0-9:_-]+`' "$root/AGENTS.md" | tr -d '`' | sort -u)
fi

if [ "$problems" -gt 0 ]; then
  echo "→ $problems vấn đề. Gợi ý: /docs-drift để audit sâu (read-only)."
  exit 1
fi
exit 0
