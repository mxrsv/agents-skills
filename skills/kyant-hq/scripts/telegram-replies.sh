#!/usr/bin/env bash
# Print the messages people (not bots) wrote in the Kyant HQ group since the last read,
# one per line as: <UTC time> TAB <sender> TAB <text>. Marks them read unless --peek.
# Only the CEO bot reads (its privacy mode is off). Telegram keeps unread updates for
# about 24 hours, so read at least once a day.
# Usage: telegram-replies.sh [--peek]
set -euo pipefail

readonly STATE_DIR="${KYANT_HQ_STATE_DIR:-$HOME/.config/company-bot}"
readonly ENV_FILE="${KYANT_HQ_ENV:-$STATE_DIR/env}"
readonly OFFSET_FILE="$STATE_DIR/updates-offset"
readonly API_BASE="https://api.telegram.org"
readonly TIMEOUT_SECONDS=20

peek=false
if [ "${1:-}" = "--peek" ]; then
  peek=true
elif [ "$#" -gt 0 ]; then
  echo "usage: telegram-replies.sh [--peek]" >&2
  exit 2
fi

if [ ! -f "$ENV_FILE" ]; then
  echo "missing $ENV_FILE" >&2
  exit 1
fi
# shellcheck disable=SC1090
. "$ENV_FILE"

token="${TELEGRAM_BOT_TOKEN_CEO:-}"
chat_id="${TELEGRAM_CHAT_ID:-}"
if [ -z "$token" ] || [ -z "$chat_id" ]; then
  echo "TELEGRAM_BOT_TOKEN_CEO or TELEGRAM_CHAT_ID is empty in $ENV_FILE" >&2
  exit 1
fi

offset=0
if [ -f "$OFFSET_FILE" ]; then
  offset="$(cat "$OFFSET_FILE")"
fi

response="$(curl -sS --max-time "$TIMEOUT_SECONDS" \
  "$API_BASE/bot${token}/getUpdates" \
  --data-urlencode "offset=${offset}")"

if [ "$(jq -r '.ok' <<<"$response")" != "true" ]; then
  echo "read failed: $(jq -r '.description // "no description"' <<<"$response")" >&2
  exit 1
fi

jq -r --arg chat "$chat_id" '
  .result[]
  | .message // empty
  | select((.chat.id | tostring) == $chat and (.from.is_bot | not))
  | [(.date | todate), .from.first_name, ((.text // "[not a text message]") | gsub("[\\n\\t]"; " "))]
  | @tsv
' <<<"$response"

if [ "$peek" = false ]; then
  next_offset="$(jq -r '[.result[].update_id] | if length == 0 then empty else max + 1 end' <<<"$response")"
  if [ -n "$next_offset" ]; then
    printf '%s\n' "$next_offset" >"$OFFSET_FILE"
  fi
fi
