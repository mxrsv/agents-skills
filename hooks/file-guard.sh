#!/usr/bin/env bash
# file-guard.sh — chốt chặn tên file rác + cảnh báo vùng xám cho AI agent.
# Đăng ký trong ~/.claude/settings.json:
#   PreToolUse  (Write) → file-guard.sh block   # exit 2 = CHẶN Write, stderr đưa cho agent
#   PostToolUse (Write) → file-guard.sh warn    # exit 2 = nhắc agent (tool đã chạy, không chặn)
# Từ 2026-07-27: CÓ kiểm vị trí + tên tài liệu (D3/D4). Lý do đảo chủ đích cũ: F2 dạng
# văn bản đã thất bại — 4 đường dẫn song song, 21 file bị .gitignore chôn ở deck.
# Since 2026-09-18: docs/ allows three living tiers plus technical plans/.
# Requirements share the task plan; reports default to chat. Separate spec/review directories stay blocked.
# Documentation root xác định KHÔNG qua git (xem docs_path_violation).
set -u

mode="${1:-block}"
input=$(cat)
file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null) || file_path=""
[ -z "$file_path" ] && exit 0
base=$(basename "$file_path")

WORKFLOW_HINT="requirements + plan + handoff → docs/plans/YYYY-MM-DD-<slug>.md; review → chat or an explicitly requested PR (D4)"

# Documentation root = tổ tiên gần nhất có `docs/` là con trực tiếp VÀ có marker.
# KHÔNG dùng git: PreToolUse chạy TRƯỚC khi Write tạo thư mục cha, nên
# `git -C <dir chưa tồn tại>` trả exit 128 và bị hiểu nhầm thành "ngoài repo" → fail-open.
docs_path_violation() { # $1 = file_path; in lý do chặn ra stdout, rỗng = cho qua
  local p="$1" root rel base
  case "$p" in */docs/*) ;; *) return 0 ;; esac
  root="${p%/docs/*}"
  [ -e "$root/.git" ] || [ -f "$root/AGENTS.md" ] \
    || grep -qxF "$root" "$HOME/.claude/docs-roots" 2>/dev/null || return 0
  [ -f "$root/PIPELINE.lock" ] && return 0   # D2 — miễn D3/D4
  [ -e "$p" ] && return 0                    # chỉ chặn TẠO FILE MỚI (doc legacy vẫn sửa được)
  rel="${p#"$root"/}"
  case "$rel" in
    docs/user/*|docs/internals/*|docs/operations/*|docs/plans/*) ;; # D3/D4
    docs/specs/*|docs/review/*|docs/superpowers/*|docs/intent/*|docs/decisions/*|docs/daily/*|docs/archive/*|docs/mockups/*)
      echo "⛔ D4: '$rel' — do not create spec/review/ledger files in the repo: $WORKFLOW_HINT. Evidence → scratchpad or a requested artifact destination." ;;
    docs/*/*)
      echo "⛔ D3: allowed docs/ directories: user/, internals/, operations/, plans/ — got '$rel'. Requirements, tasks and handoff → docs/plans/." ;;
    docs/*)
      base="${rel#docs/}"
      case "$base" in
        README.md|DESIGN-LANGUAGE.md) ;;
        *) echo "⛔ D3: file thẳng trong docs/ chỉ được là README.md (index) hoặc DESIGN-LANGUAGE.md — nhận '$base'. Kiến trúc/quyết định → docs/internals/, task progress → docs/plans/." ;;
      esac ;;
  esac
  return 0
}

if [ "$mode" = "block" ]; then
  case "$base" in
    *.bak|*.old|*.orig|*-v2.*|*-v3.*|*-final.*|*-copy.*)
      echo "⛔ F3/L3: tên file '$base' thuộc pattern cấm (.bak/.old/.orig/-v2/-v3/-final/-copy). Sửa trực tiếp file gốc — git giữ lịch sử; bản nháp/thí nghiệm → scratchpad." >&2
      exit 2
      ;;
  esac
  msg=$(docs_path_violation "$file_path")
  if [ -n "$msg" ]; then echo "$msg" >&2; exit 2; fi
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
case "$file_path" in
  */.planning/*) warn="${warn}${warn:+ }⚠️ D4: '.planning/' không còn dùng — $WORKFLOW_HINT." ;;
esac
if [ -n "$warn" ]; then
  echo "$warn" >&2
  exit 2
fi
exit 0
