#!/usr/bin/env bash
# file-guard.sh — chốt chặn tên file rác + cảnh báo vùng xám cho AI agent.
# Đăng ký trong ~/.claude/settings.json:
#   PreToolUse  (Write) → file-guard.sh block   # exit 2 = CHẶN Write, stderr đưa cho agent
#   PostToolUse (Write) → file-guard.sh warn    # exit 2 = nhắc agent (tool đã chạy, không chặn)
# Chủ đích KHÔNG kiểm tra vị trí file theo cấu trúc project — việc đó cần ngữ cảnh, thuộc về F2 (văn bản).
set -u

mode="${1:-block}"
input=$(cat)
file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null) || file_path=""
[ -z "$file_path" ] && exit 0
base=$(basename "$file_path")

if [ "$mode" = "block" ]; then
  case "$base" in
    *.bak|*.old|*.orig|*-v2.*|*-v3.*|*-final.*|*-copy.*)
      echo "⛔ F3/L3: tên file '$base' thuộc pattern cấm (.bak/.old/.orig/-v2/-v3/-final/-copy). Sửa trực tiếp file gốc — git giữ lịch sử; bản nháp/thí nghiệm → scratchpad." >&2
      exit 2
      ;;
  esac
  exit 0
fi

# mode = warn — không bao giờ chặn, chỉ nhắc
warn=""
lines=$(printf '%s' "$input" | jq -r '.tool_input.content // empty' 2>/dev/null | wc -l | tr -d ' ')
if [ "${lines:-0}" -gt 800 ]; then
  warn="⚠️ C2/F8: file '$base' dài ${lines} dòng (>800). Tách module theo rules của ngôn ngữ tương ứng."
fi
case "$base" in
  debug-*|tmp-*|scratch-*|*.log)
    case "$file_path" in
      */scratchpad/*|/tmp/*|/private/tmp/*) ;;
      *) warn="${warn}${warn:+ }⚠️ F4/L4: '$base' có vẻ là file tạm/debug nhưng nằm ngoài scratchpad." ;;
    esac
    ;;
esac
if [ -n "$warn" ]; then
  echo "$warn" >&2
  exit 2
fi
exit 0
