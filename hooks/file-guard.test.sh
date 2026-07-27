#!/usr/bin/env bash
# Tests for file-guard.sh. Run: bash ~/.claude/hooks/file-guard.test.sh
# GUARD_OVERRIDE: đường dẫn bản guard đang phát triển (scratchpad) để test mà không đụng hook live.
set -u
GUARD="${GUARD_OVERRIDE:-$(cd "$(dirname "$0")" && pwd)/file-guard.sh}"
pass=0; fail=0

check() { # desc expected_exit mode json
  local desc="$1" expected="$2" mode="$3" json="$4" actual
  printf '%s' "$json" | bash "$GUARD" "$mode" >/dev/null 2>&1
  actual=$?
  if [ "$actual" -eq "$expected" ]; then pass=$((pass+1)); echo "PASS: $desc"
  else fail=$((fail+1)); echo "FAIL: $desc (expected $expected, got $actual)"; fi
}

big_content_json=$(jq -cn '{tool_input:{file_path:"/repo/big.ts", content:([range(900)] | map("line") | join("\n"))}}')

check "block: .bak"                    2 block '{"tool_input":{"file_path":"/repo/src/auth.ts.bak"}}'
check "block: .old"                    2 block '{"tool_input":{"file_path":"/repo/config.old"}}'
check "block: -v2"                     2 block '{"tool_input":{"file_path":"/repo/src/auth-v2.ts"}}'
check "block: -final"                  2 block '{"tool_input":{"file_path":"/repo/notes-final.md"}}'
check "block: -copy"                   2 block '{"tool_input":{"file_path":"/repo/page-copy.tsx"}}'
check "block: file thường đi qua"      0 block '{"tool_input":{"file_path":"/repo/src/auth.ts"}}'
check "block: tên chứa v2 giữa từ OK"  0 block '{"tool_input":{"file_path":"/repo/src/openapi-v2-client/index.ts"}}'
check "block: không có file_path OK"   0 block '{"tool_input":{}}'
check "block: JSON hỏng không nổ"      0 block 'not-json'
check "warn: >800 dòng cảnh báo"       2 warn  "$big_content_json"
check "warn: file nhỏ im lặng"         0 warn  '{"tool_input":{"file_path":"/repo/small.ts","content":"hello"}}'
check "warn: debug-* trong repo"       2 warn  '{"tool_input":{"file_path":"/repo/debug-probe.js","content":"x"}}'
check "warn: debug-* trong scratchpad OK" 0 warn '{"tool_input":{"file_path":"/private/tmp/claude-501/x/scratchpad/debug-probe.js","content":"x"}}'
check "warn: *.log trong repo"         2 warn  '{"tool_input":{"file_path":"/repo/out.log","content":"x"}}'

# ---- nhánh vị trí & tên tài liệu ----
FIX=$(mktemp -d)
mkdir -p "$FIX/repo/.git" "$FIX/repo/docs/specs" "$FIX/repo/docs/plans" \
         "$FIX/repo/docs/review/assets" "$FIX/repo/docs/mockups" \
         "$FIX/plainsrc/apps/web/src/docs" "$FIX/pipeline/.git" "$FIX/pipeline/docs"
: > "$FIX/repo/docs/PRD.md"
: > "$FIX/pipeline/PIPELINE.lock"
jp() { jq -cn --arg p "$1" '{tool_input:{file_path:$p}}'; }

check "docs: thư mục cha CHƯA tồn tại vẫn chặn" 2 block "$(jp "$FIX/repo/docs/superpowers/specs/x.md")"
check "docs: thư mục lạ bị chặn"                2 block "$(jp "$FIX/repo/docs/intent/x.md")"
check "docs: decisions/ mới bị chặn"            2 block "$(jp "$FIX/repo/docs/decisions/0030-x.md")"
check "docs: tên spec sai bị chặn"              2 block "$(jp "$FIX/repo/docs/specs/foo.md")"
check "docs: FINAL.md trong specs bị chặn"      2 block "$(jp "$FIX/repo/docs/specs/FINAL.md")"
check "docs: plan .txt bị chặn"                 2 block "$(jp "$FIX/repo/docs/plans/x.txt")"
check "docs: review thiếu ngày bị chặn"         2 block "$(jp "$FIX/repo/docs/review/no-date.md")"
check "docs: mockup .zip bị chặn"               2 block "$(jp "$FIX/repo/docs/mockups/foo.zip")"
check "docs: file HOA lạ bị chặn"               2 block "$(jp "$FIX/repo/docs/FOO.md")"
check "docs: spec đúng tên cho qua"             0 block "$(jp "$FIX/repo/docs/specs/2026-07-27-x-design.md")"
check "docs: plan đúng tên cho qua"             0 block "$(jp "$FIX/repo/docs/plans/2026-07-27-x.md")"
check "docs: review/assets tự do cho qua"       0 block "$(jp "$FIX/repo/docs/review/assets/a.png")"
check "docs: mockup đúng tên cho qua"           0 block "$(jp "$FIX/repo/docs/mockups/2026-07-27-x.html")"
check "docs: ARCHITECTURE.md cho qua"           0 block "$(jp "$FIX/repo/docs/ARCHITECTURE.md")"
check "docs: file ĐÃ tồn tại cho qua"           0 block "$(jp "$FIX/repo/docs/PRD.md")"
check "docs: PIPELINE.lock miễn trừ"            0 block "$(jp "$FIX/pipeline/docs/intent/x.md")"
check "docs: docs trong src cho qua"            0 block "$(jp "$FIX/plainsrc/apps/web/src/docs/foo.md")"
check "warn: .planning nhắc chuyển"             2 warn  '{"tool_input":{"file_path":"/repo/.planning/x.md","content":"x"}}'
rm -rf "$FIX"

echo "----"
echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
