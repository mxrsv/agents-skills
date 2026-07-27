#!/usr/bin/env bash
# file-guard.sh — chốt chặn tên file rác + cảnh báo vùng xám cho AI agent.
# Đăng ký trong ~/.claude/settings.json:
#   PreToolUse  (Write) → file-guard.sh block   # exit 2 = CHẶN Write, stderr đưa cho agent
#   PostToolUse (Write) → file-guard.sh warn    # exit 2 = nhắc agent (tool đã chạy, không chặn)
# Từ 2026-07-27: CÓ kiểm vị trí + tên tài liệu (D3/D4). Lý do đảo chủ đích cũ: F2 dạng
# văn bản đã thất bại — 4 đường dẫn song song, 21 file bị .gitignore chôn ở deck.
# Documentation root xác định KHÔNG qua git (xem docs_path_violation).
set -u

mode="${1:-block}"
input=$(cat)
file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null) || file_path=""
[ -z "$file_path" ] && exit 0
base=$(basename "$file_path")

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
  [ -e "$p" ] && return 0                    # chỉ chặn TẠO FILE MỚI
  rel="${p#"$root"/}"
  case "$rel" in
    docs/superpowers/*)
      echo "⛔ D4: 'docs/superpowers/' đã bỏ. Spec → docs/specs/YYYY-MM-DD-<topic>-design.md; plan → docs/plans/YYYY-MM-DD-<topic>.md" ;;
    docs/review/assets/*) ;;
    docs/specs/*)
      base="${rel#docs/specs/}"
      printf '%s' "$base" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}-[^/]+-design\.md$' \
        || echo "⛔ D4: tên spec phải khớp YYYY-MM-DD-<topic>-design.md — nhận '$base'" ;;
    docs/plans/*)
      base="${rel#docs/plans/}"
      printf '%s' "$base" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}-[^/]+\.md$' \
        || echo "⛔ D4: tên plan phải khớp YYYY-MM-DD-<topic>.md — nhận '$base'" ;;
    docs/review/*)
      base="${rel#docs/review/}"
      printf '%s' "$base" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}-[^/]+\.md$' \
        || echo "⛔ D4: tên review phải khớp YYYY-MM-DD-<topic>.md — nhận '$base' (ảnh → docs/review/assets/)" ;;
    docs/mockups/*)
      base="${rel#docs/mockups/}"
      printf '%s' "$base" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}-[^/]+\.(html|png|jpg|svg)$' \
        || echo "⛔ D4: tên mockup phải khớp YYYY-MM-DD-<topic>.{html,png,jpg,svg} — nhận '$base'" ;;
    docs/*/*)
      echo "⛔ D3: thư mục con hợp lệ trong docs/ chỉ có specs, plans, review, mockups — nhận '$rel'" ;;
    docs/*)
      base="${rel#docs/}"
      case "$base" in
        ARCHITECTURE.md|CONTEXT.md|CODEMAP.md|OPERATIONS.md|PRODUCT.md|DESIGN.md|README.md) ;;
        *) echo "⛔ D3: file .md thẳng trong docs/ chỉ được đặt tên ARCHITECTURE, CONTEXT, CODEMAP, OPERATIONS, PRODUCT, DESIGN, README — nhận '$base'" ;;
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
  */.planning/*) warn="${warn}${warn:+ }⚠️ D4: '.planning/' không còn dùng — plan chính thức → docs/plans/YYYY-MM-DD-<topic>.md." ;;
esac
if [ -n "$warn" ]; then
  echo "$warn" >&2
  exit 2
fi
exit 0
