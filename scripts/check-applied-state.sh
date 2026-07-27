#!/usr/bin/env bash
# So settings.json thật với templates/settings.reference.json.
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

[ $bad -eq 0 ] && echo "✅ settings khớp reference"
exit $bad
