#!/usr/bin/env bash
# Send one message to the Kyant HQ Telegram group as one role's bot.
# Usage: telegram-send.sh <ceo|customer> <text>
set -euo pipefail

readonly ENV_FILE="${KYANT_HQ_ENV:-$HOME/.config/company-bot/env}"
readonly API_BASE="https://api.telegram.org"
readonly TIMEOUT_SECONDS=20
readonly MAX_TEXT_LENGTH=4096 # Telegram's limit for one message

if [ "$#" -ne 2 ]; then
  echo "usage: telegram-send.sh <ceo|customer> <text>" >&2
  exit 2
fi

role="$1"
text="$2"

case "$role" in
  ceo) token_var="TELEGRAM_BOT_TOKEN_CEO" ;;
  customer) token_var="TELEGRAM_BOT_TOKEN_CUSTOMER" ;;
  *)
    echo "unknown role '$role' (expected ceo or customer)" >&2
    exit 2
    ;;
esac

if [ ! -f "$ENV_FILE" ]; then
  echo "missing $ENV_FILE" >&2
  exit 1
fi
# shellcheck disable=SC1090
. "$ENV_FILE"

token="${!token_var:-}"
chat_id="${TELEGRAM_CHAT_ID:-}"
if [ -z "$token" ] || [ -z "$chat_id" ]; then
  echo "$token_var or TELEGRAM_CHAT_ID is empty in $ENV_FILE" >&2
  exit 1
fi
if [ -z "$text" ] || [ "${#text}" -gt "$MAX_TEXT_LENGTH" ]; then
  echo "text must be 1..$MAX_TEXT_LENGTH characters (got ${#text})" >&2
  exit 2
fi

response="$(curl -sS --max-time "$TIMEOUT_SECONDS" \
  "$API_BASE/bot${token}/sendMessage" \
  --data-urlencode "chat_id=${chat_id}" \
  --data-urlencode "text=${text}")"

if [ "$(jq -r '.ok' <<<"$response")" != "true" ]; then
  echo "send failed: $(jq -r '.description // "no description"' <<<"$response")" >&2
  exit 1
fi

jq -r '"sent message_id=\(.result.message_id) from=\(.result.from.first_name)"' <<<"$response"
