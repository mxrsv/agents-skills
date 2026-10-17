#!/bin/sh
# SessionStart hook: nhắc chạy /skill-candidates khi lần quét transcript gần nhất đã cũ.
# W15 chỉ nhìn được một session; việc lặp lại qua nhiều session chỉ lộ ra khi quét.
# Stdout của SessionStart được Claude Code đưa vào context. Không có gì để nói → im lặng.
# Ngưỡng: SKILL_CANDIDATES_DUE_DAYS (mặc định 7). Mốc: state/skill-candidates-last-run (mtime).
STAMP="$HOME/.claude/state/skill-candidates-last-run"
DAYS="${SKILL_CANDIDATES_DUE_DAYS:-7}"
cat >/dev/null 2>&1 || :
if [ -f "$STAMP" ] && [ -n "$(find "$STAMP" -mtime "-$DAYS" 2>/dev/null)" ]; then
  exit 0
fi
printf '%s\n' "skill-candidates is due: the cross-session skill scan has not run in ${DAYS}+ days. Per W15, at the end of this session's first finished task (never mid-task), add one line at the end of Result: \`💡 Skill scan due: run /skill-candidates\`. Do not run the scan unasked."
