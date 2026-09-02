#!/usr/bin/env bash
# Kiểm tra ~/.claude đã ở trạng thái mong muốn chưa:
#   - settings.json khớp templates/settings.reference.json
#   - output-styles/*.md có frontmatter hợp lệ
#   - presets/kyant-vibe/CLAUDE.md không trôi khỏi CLAUDE.md
# Chạy: bash ~/.claude/scripts/check-applied-state.sh
set -u
S="$HOME/.claude/settings.json"
R="$HOME/.claude/templates/settings.reference.json"
bad=0
say() { echo "$1"; bad=1; }

[ -f "$S" ] || { echo "❌ thiếu $S"; exit 1; }
jq -e . "$S" >/dev/null 2>&1 || { echo "❌ $S không phải JSON hợp lệ"; exit 1; }

[ "$(jq -r '.plansDirectory // empty' "$S")" = "$(jq -r '.plansDirectory' "$R")" ] \
  || say "❌ plansDirectory lệch (cần $(jq -r '.plansDirectory' "$R"))"

for k in $(jq -r '.skillOverrides | keys[]' "$R"); do
  want=$(jq -r --arg k "$k" '.skillOverrides[$k]' "$R")
  got=$(jq -r --arg k "$k" '.skillOverrides[$k] // "MISSING"' "$S")
  [ "$got" = "$want" ] || say "❌ skillOverrides.$k = $got (cần $want)"
done

jq -e '.hooks.PreToolUse[]?.hooks[]?.command | select(test("file-guard.sh\" block"))' "$S" >/dev/null \
  || say "❌ chưa đăng ký PreToolUse file-guard.sh block"
jq -e '.hooks.PostToolUse[]?.hooks[]?.command | select(test("file-guard.sh\" warn"))' "$S" >/dev/null \
  || say "❌ chưa đăng ký PostToolUse file-guard.sh warn"

for r in $(jq -r '._docsRoots[]' "$R"); do
  grep -qxF "$r" "$HOME/.claude/docs-roots" 2>/dev/null || say "❌ docs-roots thiếu $r"
done

# --- output-styles: frontmatter hợp lệ ---
# Claude Code chỉ đọc 3 khoá này từ custom style (nguồn: binary 2.1.252).
# keep-coding-instructions thiếu => style THAY THẾ coding instructions mặc định, đổi hành vi âm thầm.
STYLES="$HOME/.claude/output-styles"
if [ -d "$STYLES" ]; then
  for f in "$STYLES"/*.md; do
    [ -e "$f" ] || continue
    fm=$(awk 'NR==1&&$0=="---"{inb=1;next} inb&&$0=="---"{exit} inb' "$f")
    [ -n "$fm" ] || { say "❌ $(basename "$f") không có frontmatter"; continue; }
    printf '%s\n' "$fm" | grep -q '^keep-coding-instructions: *true$' \
      || say "❌ $(basename "$f") thiếu 'keep-coding-instructions: true' — style sẽ thay thế coding instructions mặc định"
    printf '%s\n' "$fm" | grep -q '^name: *[^ ]' || say "❌ $(basename "$f") thiếu 'name:' (sẽ mặc định theo tên file)"
    printf '%s\n' "$fm" | grep -q '^description: *[^ ]' || say "❌ $(basename "$f") thiếu 'description:'"
  done
fi

# outputStyle trong settings.json phải trỏ tới built-in hoặc một file có 'name:' khớp.
# Built-in list lấy từ binary 2.1.252 — built-in mới sẽ báo sai ở đây cho tới khi bổ sung.
want_style=$(jq -r '.outputStyle // empty' "$S")
if [ -n "$want_style" ]; then
  case "$want_style" in
    Default|Concise|Explanatory|Learning|Proactive) ;;
    *)
      grep -rqx "name: $want_style" "$STYLES" 2>/dev/null \
        || say "❌ settings.outputStyle='$want_style' không khớp built-in nào, cũng không có output-styles/*.md nào khai 'name: $want_style'"
      ;;
  esac
fi

# --- preset không trôi khỏi CLAUDE.md ---
# <communication> + <conciseness> là phần dùng chung; lệch nghĩa là preset public đang ship luật cũ.
SRC="$HOME/.claude/CLAUDE.md"
PRESET="$HOME/.claude/presets/kyant-vibe/CLAUDE.md"
if [ -f "$SRC" ] && [ -f "$PRESET" ]; then
  blk() { sed -n '/<communication>/,/<\/conciseness>/p' "$1"; }
  diff -q <(blk "$SRC") <(blk "$PRESET") >/dev/null 2>&1 \
    || say "❌ presets/kyant-vibe/CLAUDE.md lệch CLAUDE.md ở <communication>/<conciseness> — chạy 'diff <(sed -n \'/<communication>/,/<\/conciseness>/p\' CLAUDE.md) <(sed -n \'/<communication>/,/<\/conciseness>/p\' presets/kyant-vibe/CLAUDE.md)' để xem"
fi

[ $bad -eq 0 ] && echo "✅ settings, output-styles và preset đều khớp"
exit $bad
