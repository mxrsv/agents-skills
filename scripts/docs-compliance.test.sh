#!/usr/bin/env bash
# Tests cho docs-compliance.sh. Chạy: bash ~/.claude/scripts/docs-compliance.test.sh
set -u
S="${COMPLIANCE_OVERRIDE:-$(cd "$(dirname "$0")" && pwd)/docs-compliance.sh}"
pass=0; fail=0
has() { local out; out=$(bash "$S" "$2" 2>&1)
  if printf '%s' "$out" | grep -qF "$3"; then pass=$((pass+1)); echo "PASS: $1"
  else fail=$((fail+1)); echo "FAIL: $1"; echo "  out: $out"; fi; }
hasnt() { local out; out=$(bash "$S" "$2" 2>&1)
  if printf '%s' "$out" | grep -qF "$3"; then fail=$((fail+1)); echo "FAIL: $1"; echo "  out: $out"
  else pass=$((pass+1)); echo "PASS: $1"; fi; }
code() { bash "$S" "$2" >/dev/null 2>&1; local c=$?
  if [ "$c" -eq "$3" ]; then pass=$((pass+1)); echo "PASS: $1"
  else fail=$((fail+1)); echo "FAIL: $1 (exit $c, cần $3)"; fi; }

A=$(mktemp -d)
code  "repo trắng trơn exit 1"                 "$A" 1
has   "báo thiếu AGENTS.md"                    "$A" "AGENTS.md"
hasnt "KHÔNG còn đòi docs/ARCHITECTURE.md"     "$A" "ARCHITECTURE.md"
hasnt "KHÔNG còn đòi docs/CONTEXT.md"          "$A" "CONTEXT.md"

B=$(mktemp -d)
printf '# a\n' > "$B/AGENTS.md"
printf '# claude\n' > "$B/CLAUDE.md"
has "báo CLAUDE.md thiếu @AGENTS.md" "$B" "@AGENTS.md"

# cặp AGENTS.md + CLAUDE.md là đủ D5 — không cần docs/ gì cả, không cần mục drift
C=$(mktemp -d)
printf '# a\n' > "$C/AGENTS.md"
printf '@AGENTS.md\n' > "$C/CLAUDE.md"
code  "cặp AGENTS+CLAUDE không docs/ exit 0"  "$C" 0
hasnt "không còn đòi mục Chưa khớp thực tế"   "$C" "Chưa khớp thực tế"

D=$(mktemp -d); mkdir -p "$D/docs/internals"
printf '# a\n[x](src/y.ts)\n' > "$D/AGENTS.md"
printf '@AGENTS.md\n' > "$D/CLAUDE.md"
printf '# overview\n[z](../../src/y.ts)\n' > "$D/docs/internals/overview.md"
hasnt "link không nhãn KHÔNG còn bị báo"        "$D" "nhãn ý định"
code  "AGENTS+CLAUDE đủ D5 exit 0"              "$D" 0

E=$(mktemp -d); mkdir -p "$E/docs/user" "$E/docs/internals" "$E/docs/operations"
printf '# a\n[x](src/y.ts) `current`\n' > "$E/AGENTS.md"
printf '@AGENTS.md\n' > "$E/CLAUDE.md"
printf '# index\n[u](user/a.md)\n' > "$E/docs/README.md"
printf '# u\n' > "$E/docs/user/a.md"
code "repo ba tầng đủ hết exit 0" "$E" 0

E2=$(mktemp -d)
printf '# a\n[x](y.md)\n`current`\n' > "$E2/AGENTS.md"
printf '@AGENTS.md\n' > "$E2/CLAUDE.md"
code "nhãn D6 ở dòng kế tiếp exit 0" "$E2" 0

F=$(mktemp -d); mkdir -p "$F/docs/specs"; : > "$F/PIPELINE.lock"
printf '# a\n[x](y.md)\n' > "$F/AGENTS.md"
printf '@AGENTS.md\n' > "$F/CLAUDE.md"
code  "PIPELINE.lock đủ D5 exit 0"       "$F" 0
hasnt "PIPELINE.lock bỏ qua cảnh báo D3" "$F" "docs/specs/"

G=$(mktemp -d); mkdir -p "$G/docs"; : > "$G/PIPELINE.lock"
code "PIPELINE.lock KHÔNG miễn D5" "$G" 1

# thư mục legacy: cảnh báo, không đổi exit — repo dọn theo issue riêng
H=$(mktemp -d); mkdir -p "$H/docs/specs" "$H/docs/review" "$H/docs/internals"
printf '# a\n' > "$H/AGENTS.md"
printf '@AGENTS.md\n' > "$H/CLAUDE.md"
has  "cảnh báo docs/specs/ còn tồn tại"  "$H" "⚠️ docs/specs/"
has  "cảnh báo docs/review/ còn tồn tại" "$H" "⚠️ docs/review/"
code "thư mục legacy không làm exit 1"   "$H" 0

rm -rf "$A" "$B" "$C" "$D" "$E" "$E2" "$F" "$G" "$H"
echo "----"; echo "pass=$pass fail=$fail"; [ "$fail" -eq 0 ]
