#!/usr/bin/env bash
# Tests for file-guard.sh. Run: bash ~/.claude/hooks/file-guard.test.sh
set -u
GUARD="$(cd "$(dirname "$0")" && pwd)/file-guard.sh"
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

echo "----"
echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
