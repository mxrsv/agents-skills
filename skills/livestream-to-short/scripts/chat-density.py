"""Bucket YouTube live_chat.json messages by video offset to find audience-reaction spikes."""
import json
import sys
from collections import Counter

BUCKET_SEC = 60
TOP_N = 15


def iter_messages(path):
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            try:
                row = json.loads(line)
            except json.JSONDecodeError:
                continue
            replay = row.get("replayChatItemAction", {})
            offset_ms = int(replay.get("videoOffsetTimeMsec", -1))
            if offset_ms < 0:
                continue
            for action in replay.get("actions", []):
                item = action.get("addChatItemAction", {}).get("item", {})
                renderer = item.get("liveChatTextMessageRenderer") or item.get("liveChatPaidMessageRenderer")
                if not renderer:
                    continue
                text = "".join(
                    run.get("text") or run.get("emoji", {}).get("shortcuts", [""])[0]
                    for run in renderer.get("message", {}).get("runs", [])
                )
                author = renderer.get("authorName", {}).get("simpleText", "?")
                yield offset_ms / 1000, author, text


def fmt(sec):
    sec = int(sec)
    return f"{sec // 3600}:{sec % 3600 // 60:02d}:{sec % 60:02d}"


def main(path):
    messages = list(iter_messages(path))
    buckets = Counter(int(t // BUCKET_SEC) for t, _, _ in messages)
    print(f"total messages: {len(messages)}, unique authors: {len({a for _, a, _ in messages})}")
    print(f"\nTop {TOP_N} busiest {BUCKET_SEC}s windows:")
    for bucket, count in buckets.most_common(TOP_N):
        start = bucket * BUCKET_SEC
        print(f"  {fmt(start)}  {count} msgs")
    print("\nAll messages:")
    for t, author, text in messages:
        print(f"{fmt(t)} | {author}: {text}")


if __name__ == "__main__":
    main(sys.argv[1])
