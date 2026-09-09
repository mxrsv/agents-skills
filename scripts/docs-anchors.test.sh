#!/usr/bin/env bash
# Tests cho docs-anchors.sh. Chạy: bash ~/.claude/scripts/docs-anchors.test.sh
set -u
S="${ANCHORS_OVERRIDE:-$(cd "$(dirname "$0")" && pwd)/docs-anchors.sh}"
pass=0; fail=0
has() { local out; out=$(bash "$S" "$2" 2>&1)
  if printf '%s' "$out" | grep -qF "$3"; then pass=$((pass+1)); echo "PASS: $1"
  else fail=$((fail+1)); echo "FAIL: $1"; echo "  out: $out"; fi; }
hasnt() { local out; out=$(bash "$S" "$2" 2>&1)
  if printf '%s' "$out" | grep -qF "$3"; then fail=$((fail+1)); echo "FAIL: $1"; echo "  out: $out"
  else pass=$((pass+1)); echo "PASS: $1"; fi; }
empty() { local out; out=$(bash "$S" "$2" 2>&1)
  if [ -z "$out" ]; then pass=$((pass+1)); echo "PASS: $1"
  else fail=$((fail+1)); echo "FAIL: $1"; echo "  out: $out"; fi; }

R=$(mktemp -d); mkdir -p "$R/docs/specs" "$R/docs/internals/pty" "$R/docs/user" "$R/src"
printf 'line\n%.0s' $(seq 50) > "$R/src/real.ts"
printf 'const AGENT_ALLOWLIST = ["a"];\n#[allow(dead_code)]\npty_spawn();\n' > "$R/src/sym.rs"
: > "$R/docs/internals/sibling.md"

cat > "$R/docs/internals/overview.md" <<'EOF'
# A
Anh em cùng thư mục — [s](sibling.md)
Ra ngoài repo root — [real](../../src/real.ts)
Chết — [gone](../../src/gone.ts)
Dòng quá — [x](../../src/real.ts#L9999)
Khoảng quá — [y](../../src/real.ts#L10-L9999)
Symbol có — [z](../../src/sym.rs#AGENT_ALLOWLIST)
Symbol chứa regex — [w](../../src/sym.rs##[allow(dead_code)])
Symbol sai — [v](../../src/sym.rs#pty.spawn)
Ngoài — [u](https://example.com) và [t](#muc-1)
Không phải anchor: `@preact/signals` `--text-primary/muted` `mxrsv/stackgrid` `TabView.unread`
EOF
printf '# deep\n[lồng sâu chết](../../../src/nope.ts)\n' > "$R/docs/internals/pty/ownership.md"
printf '# user\n[trang chị em](../internals/overview.md)\n[chết](missing.md)\n' > "$R/docs/user/getting-started.md"
printf '# index\n[u](user/getting-started.md)\n[ảnh phá cache](../src/real.ts?v=1.0.0)\n' > "$R/docs/README.md"
printf '[đóng băng](../src/gone.ts)\n' > "$R/docs/specs/2026-07-27-x-design.md"

hasnt "link anh em cùng thư mục resolve đúng"  "$R" "[sibling.md]"
hasnt "link ../../src/real.ts resolve đúng"    "$R" "[../../src/real.ts] —"
has   "báo file không tồn tại"                 "$R" "../../src/gone.ts"
has   "báo #L vượt số dòng"                    "$R" "#L9999"
has   "báo M vượt số dòng"                     "$R" "L10-L9999"
hasnt "symbol chứa regex không false-negative" "$R" "#[allow(dead_code)] — symbol"
has   "symbol sai bị báo"                      "$R" "pty.spawn"
hasnt "link ngoài bị bỏ qua"                   "$R" "example.com"
hasnt "inline code không phải anchor"          "$R" "@preact/signals"
has   "internals/ lồng sâu được quét"          "$R" "internals/pty/ownership.md:2"
has   "user/ được quét"                        "$R" "user/getting-started.md:3"
hasnt "user/ link sang internals resolve đúng" "$R" "[../internals/overview.md]"
hasnt "docs/README.md link đúng không báo"     "$R" "README.md:2"
hasnt "query string ?v= không làm link chết"   "$R" "README.md:3"
hasnt "docs/specs/ legacy, không quét"         "$R" "2026-07-27-x-design.md"

R2=$(mktemp -d); mkdir -p "$R2/docs/internals"
printf '# A\n[ok](x.md)\n[heading](x.md#10-verification-and-acceptance)\n[em dash](x.md#pane-detach--phase-a-landed-2026-08-10)\n' > "$R2/docs/internals/overview.md"
printf '# 10. Verification and acceptance\n\n## Pane detach — Phase A landed 2026-08-10\n' > "$R2/docs/internals/x.md"
empty "tài liệu sạch im lặng" "$R2"

R3=$(mktemp -d)
empty "repo không có tài liệu sống" "$R3"

rm -rf "$R" "$R2" "$R3"
echo "----"; echo "pass=$pass fail=$fail"; [ "$fail" -eq 0 ]
