"""Merge whisper JSON segments into ~20s lines prefixed with H:MM:SS for fast reading."""
import json
import sys

WINDOW_SEC = 20


def fmt(sec):
    sec = int(sec)
    return f"{sec // 3600}:{sec % 3600 // 60:02d}:{sec % 60:02d}"


def main(path):
    with open(path, encoding="utf-8") as fh:
        segments = json.load(fh)["transcription"]
    line_start, parts = None, []
    for seg in segments:
        start = seg["offsets"]["from"] / 1000
        text = seg["text"].strip()
        if not text:
            continue
        if line_start is None:
            line_start = start
        parts.append(text)
        if start - line_start >= WINDOW_SEC:
            print(f"{fmt(line_start)} {' '.join(parts)}")
            line_start, parts = None, []
    if parts:
        print(f"{fmt(line_start)} {' '.join(parts)}")


if __name__ == "__main__":
    main(sys.argv[1])
