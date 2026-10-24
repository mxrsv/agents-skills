"""Print whisper segments within [start, end] seconds as H:MM:SS.s text."""
import json
import sys


def fmt(sec):
    return f"{int(sec) // 3600}:{int(sec) % 3600 // 60:02d}:{sec % 60:04.1f}"


segments = json.load(open(sys.argv[1], encoding="utf-8"))["transcription"]
for start_s, end_s in zip(sys.argv[2::2], sys.argv[3::2]):
    lo, hi = float(start_s), float(end_s)
    print(f"===== {fmt(lo)} -> {fmt(hi)}")
    for seg in segments:
        a, b = seg["offsets"]["from"] / 1000, seg["offsets"]["to"] / 1000
        if b >= lo and a <= hi:
            print(f"{fmt(a)}-{fmt(b)} {seg['text'].strip()}")
