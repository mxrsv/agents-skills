#!/usr/bin/env bash
# Đồng bộ skill chính giữa ~/.claude (nguồn, git track) và ~/.agents (kho chung Codex + Cursor đọc).
#   - Skill chính = thư mục THẬT trong ~/.claude/skills mà git đang track.
#   - Mỗi skill chính: ~/.agents/skills/<x> phải là symlink → ../../.claude/skills/<x>
#     (Codex đọc ~/.agents/skills natively và theo symlink; Claude Code đọc ~/.claude/skills).
#   - ~/.agents/templates → ../.claude/templates (review-report.md dùng chung).
#   - Frontmatter: `name` khớp tên thư mục (Codex gọi $name); chỉ dùng khoá Claude Code hoặc Codex đọc.
#   - Báo bản copy trùng tên trong ~/.codex/skills — Codex sẽ thấy hai skill cùng tên.
# Chạy: bash ~/.claude/scripts/sync-agents-skills.sh [--check]
#   --check : chỉ báo cáo, exit 1 nếu lệch, không tạo symlink.
# Script KHÔNG xoá gì — thư mục thật ở đích chỉ được báo, gộp tay rồi xoá.
set -u
CLAUDE="$HOME/.claude"; AGENTS="$HOME/.agents"; CODEX="$HOME/.codex"
CHECK=0; [ "${1:-}" = "--check" ] && CHECK=1
bad=0; say() { echo "$1"; bad=$((bad + 1)); }
# Claude Code: name description argument-hint disable-model-invocation user-invocable allowed-tools model context agent hooks effort
# Codex (skill-creator/quick_validate.py): name description license allowed-tools metadata
KNOWN_KEYS=" name description license allowed-tools metadata argument-hint disable-model-invocation user-invocable effort model context agent hooks "

main_skills() {
  local n
  for n in $(git -C "$CLAUDE" ls-files skills | cut -d/ -f2 | sort -u); do
    [ -d "$CLAUDE/skills/$n" ] && [ ! -L "$CLAUDE/skills/$n" ] && echo "$n"
  done
}

ensure_link() { # $1 = link path, $2 = target tương đối
  local link="$1" target="$2"
  if [ -L "$link" ]; then
    [ "$(readlink "$link")" = "$target" ] && [ -e "$link" ] && return 0
    say "❌ $link → $(readlink "$link") (mong đợi $target)"; return 1
  fi
  if [ -e "$link" ]; then say "❌ $link là thư mục thật — hai nguồn; gộp tay rồi thay bằng symlink"; return 1; fi
  if [ $CHECK -eq 1 ]; then say "❌ thiếu symlink $link → $target"; return 1; fi
  ln -s "$target" "$link" && echo "✅ tạo $link → $target"
}

check_frontmatter() { # $1 = tên skill
  local f="$CLAUDE/skills/$1/SKILL.md" fm name k
  [ -f "$f" ] || { say "❌ $1: thiếu SKILL.md"; return; }
  fm=$(awk 'NR==1&&$0=="---"{inb=1;next} inb&&$0=="---"{exit} inb' "$f")
  [ -n "$fm" ] || { say "❌ $1: không có frontmatter"; return; }
  name=$(printf '%s\n' "$fm" | sed -n 's/^name:[[:space:]]*//p' | head -1)
  [ "$name" = "$1" ] || say "❌ $1: frontmatter name='$name' khác tên thư mục (Codex gọi theo name)"
  printf '%s\n' "$fm" | grep -q '^description:[[:space:]]*[^[:space:]]' || say "❌ $1: thiếu description"
  for k in $(printf '%s\n' "$fm" | grep -o '^[a-z][a-z-]*:' | tr -d ':'); do
    case "$KNOWN_KEYS" in *" $k "*) ;; *) say "❌ $1: khoá frontmatter '$k' không harness nào đọc — bỏ hoặc chuyển vào metadata" ;; esac
  done
}

[ $CHECK -eq 1 ] || mkdir -p "$AGENTS/skills"
count=0
for n in $(main_skills); do
  count=$((count + 1))
  ensure_link "$AGENTS/skills/$n" "../../.claude/skills/$n"
  check_frontmatter "$n"
  if [ -d "$CODEX/skills/$n" ] && [ ! -L "$CODEX/skills/$n" ]; then
    say "❌ ~/.codex/skills/$n là bản copy — Codex đã đọc ~/.agents/skills/$n, xoá bản copy để khỏi trùng tên"
  fi
done
ensure_link "$AGENTS/templates" "../.claude/templates"

[ $bad -eq 0 ] && echo "✅ $count skill chính đồng bộ ~/.claude ↔ ~/.agents, frontmatter hợp lệ"
exit $(( bad > 0 ))
