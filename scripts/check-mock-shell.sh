#!/usr/bin/env bash
# check-mock-shell.sh <mock.html>... — mock có dựng trên khung chung không (UP8, rules/quality/ui-process.md).
#   1. <html> mang data-mock-shell.
#   2. Các khối SHELL (CSS, khung HTML, JS) giống hệt templates/mock-shell.html; mock chỉ được sửa hai khối MOCK.
#   3. CSS của mock không đụng tới selector của khung (dải phải, canvas).
# Không kiểm: JS của mock có chạy không — mở trang lên xem.
# Chạy: bash ~/.claude/scripts/check-mock-shell.sh path/to/mock.html   (exit 1 nếu lệch, 2 nếu gọi sai)
# Giới hạn: chỉ so với template hiện tại — đổi khung thì mock cũ sẽ báo lệch; khi đó tăng số ở
# data-mock-shell và so theo từng phiên bản.
set -u
TEMPLATE="$HOME/.claude/templates/mock-shell.html"
[ $# -gt 0 ] || { echo "dùng: check-mock-shell.sh <mock.html>..." >&2; exit 2; }
[ -f "$TEMPLATE" ] || { echo "❌ thiếu $TEMPLATE" >&2; exit 2; }

# In các khối SHELL: từ dòng mốc SHELL tới dòng mốc MOCK kế tiếp hoặc tới </script>.
shell_blocks() {
  awk 'index($0, "---------- SHELL (do not edit) ----------") { on = 1 }
       index($0, "---------- MOCK:") || index($0, "</script>") { on = 0 }
       on' "$1"
}

# CSS của mock: từ dòng mốc "MOCK: stage CSS" tới </style>.
mock_css() { awk 'index($0, "---------- MOCK: stage CSS") { on = 1 } index($0, "</style>") { on = 0 } on' "$1"; }
SHELL_SELECTORS='#rail|#canvas|#grip|#copy|#hide|\.presets|\.opts|\.gaps|rail-min|shell-error'

want=$(shell_blocks "$TEMPLATE")
[ -n "$want" ] || { echo "❌ không tìm thấy khối SHELL trong $TEMPLATE" >&2; exit 2; }
bad=0
for f in "$@"; do
  if [ ! -f "$f" ]; then echo "❌ $f: không có file"; bad=1; continue; fi
  if ! grep -q '<html[^>]*data-mock-shell' "$f"; then
    echo "❌ $f: <html> thiếu data-mock-shell — chưa dựng từ templates/mock-shell.html"; bad=1; continue
  fi
  if mock_css "$f" | grep -qE "$SHELL_SELECTORS"; then
    echo "❌ $f: CSS của mock đụng tới khung: $(mock_css "$f" | grep -oE "$SHELL_SELECTORS" | sort -u | tr '\n' ' ')"; bad=1; continue
  fi
  if [ "$(shell_blocks "$f")" = "$want" ]; then
    echo "✅ $f"
  else
    echo "❌ $f: khối SHELL khác template — chỉ sửa hai khối MOCK"
    diff <(printf '%s\n' "$want") <(shell_blocks "$f") | head -6
    bad=1
  fi
done
exit $bad
