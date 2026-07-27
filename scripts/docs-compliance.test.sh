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

DRIFT='## Chưa khớp thực tế'

A=$(mktemp -d)
code "repo trắng trơn exit 1"          "$A" 1
has  "báo thiếu AGENTS.md"             "$A" "AGENTS.md"
has  "báo thiếu docs/ARCHITECTURE.md"  "$A" "docs/ARCHITECTURE.md"

B=$(mktemp -d); mkdir -p "$B/docs"
printf '# a\n%s\n' "$DRIFT" > "$B/AGENTS.md"
printf '# claude\n' > "$B/CLAUDE.md"
printf '# arch\n%s\n' "$DRIFT" > "$B/docs/ARCHITECTURE.md"
printf '# ctx\n%s\n' "$DRIFT" > "$B/docs/CONTEXT.md"
has "báo CLAUDE.md thiếu @AGENTS.md" "$B" "@AGENTS.md"

C=$(mktemp -d); mkdir -p "$C/docs"
printf '# a\n%s\n' "$DRIFT" > "$C/AGENTS.md"
printf '@AGENTS.md\n' > "$C/CLAUDE.md"
printf '# arch\n' > "$C/docs/ARCHITECTURE.md"
printf '# ctx\n%s\n' "$DRIFT" > "$C/docs/CONTEXT.md"
has "báo thiếu mục Chưa khớp thực tế" "$C" "Chưa khớp thực tế"

D=$(mktemp -d); mkdir -p "$D/docs"
printf '# a\n%s\n' "$DRIFT" > "$D/AGENTS.md"
printf '@AGENTS.md\n' > "$D/CLAUDE.md"
printf '# arch\n[x](y.md)\n%s\n' "$DRIFT" > "$D/docs/ARCHITECTURE.md"
printf '# ctx\n%s\n' "$DRIFT" > "$D/docs/CONTEXT.md"
has "báo link thiếu nhãn ý định" "$D" "nhãn ý định"

E=$(mktemp -d); mkdir -p "$E/docs"
printf '# a\n%s\n' "$DRIFT" > "$E/AGENTS.md"
printf '@AGENTS.md\n' > "$E/CLAUDE.md"
printf '# arch\n[x](y.md) `current`\n%s\n' "$DRIFT" > "$E/docs/ARCHITECTURE.md"
printf '# ctx\n%s\n' "$DRIFT" > "$E/docs/CONTEXT.md"
code "repo đủ hết exit 0" "$E" 0

F=$(mktemp -d); mkdir -p "$F/docs"; : > "$F/PIPELINE.lock"
printf '# a\n' > "$F/AGENTS.md"
printf '@AGENTS.md\n' > "$F/CLAUDE.md"
printf '# arch\n[x](y.md)\n' > "$F/docs/ARCHITECTURE.md"
printf '# ctx\n' > "$F/docs/CONTEXT.md"
code  "PIPELINE.lock đủ D5 exit 0" "$F" 0
hasnt "PIPELINE.lock bỏ qua D7"    "$F" "Chưa khớp thực tế"

G=$(mktemp -d); mkdir -p "$G/docs"; : > "$G/PIPELINE.lock"
code "PIPELINE.lock KHÔNG miễn D5" "$G" 1

rm -rf "$A" "$B" "$C" "$D" "$E" "$F" "$G"
echo "----"; echo "pass=$pass fail=$fail"; [ "$fail" -eq 0 ]
