"""Verify a rendered Short: format, duration, loudness, plus a contact sheet to eyeball.

Usage:
  python3 -I check-short.py short.mp4 [contact-sheet.jpg]
Prints PASS/FAIL per check and the contact sheet path (default /tmp/<name>-contact-sheet.jpg).
Exit code 1 when any check fails.
"""
import json
import re
import subprocess
import sys
from pathlib import Path

EXPECTED_SIZE = (1080, 1920)
EXPECTED_FPS = "30/1"
MAX_DURATION = 60.0
AV_DRIFT_MAX = 0.05  # seconds between video and audio stream length
LUFS_TARGET, LUFS_TOLERANCE = -14.0, 1.0
PEAK_MAX = -1.0  # dBFS
SHEET_COLS, SHEET_ROWS = 4, 2
THUMB_W, THUMB_H = 360, 640


def probe(path):
    out = subprocess.run(
        ["ffprobe", "-v", "error", "-show_entries",
         "stream=codec_type,width,height,r_frame_rate,duration:format=duration", "-of", "json", path],
        capture_output=True, text=True, check=True,
    ).stdout
    return json.loads(out)


def loudness(path):
    stderr = subprocess.run(
        ["ffmpeg", "-hide_banner", "-nostats", "-i", path, "-af", "ebur128=peak=true", "-f", "null", "-"],
        capture_output=True, text=True,
    ).stderr
    summary = stderr[stderr.rindex("Summary:"):]
    lufs = float(re.search(r"I:\s+(-?[\d.]+) LUFS", summary).group(1))
    peak = float(re.search(r"Peak:\s+(-?[\d.]+) dBFS", summary).group(1))
    return lufs, peak


def contact_sheet(path, duration, out):
    count = SHEET_COLS * SHEET_ROWS
    times = [duration * (i + 0.5) / count for i in range(count)]
    inputs = [arg for t in times for arg in ("-ss", f"{t:.2f}", "-i", str(path))]
    scaled = "".join(f"[{i}:v]scale={THUMB_W}:{THUMB_H},trim=end_frame=1[t{i}];" for i in range(count))
    rows = "".join(
        "".join(f"[t{r * SHEET_COLS + c}]" for c in range(SHEET_COLS)) + f"hstack={SHEET_COLS}[r{r}];"
        for r in range(SHEET_ROWS)
    )
    stack = "".join(f"[r{r}]" for r in range(SHEET_ROWS)) + f"vstack={SHEET_ROWS}"
    subprocess.run(["ffmpeg", "-v", "error", "-y", *inputs, "-filter_complex", scaled + rows + stack,
                    "-frames:v", "1", str(out)], check=True)
    return times


def main(path, sheet=None):
    path = Path(path)
    info = probe(path)
    video = next(s for s in info["streams"] if s["codec_type"] == "video")
    audio = next((s for s in info["streams"] if s["codec_type"] == "audio"), None)
    duration = float(info["format"]["duration"])
    lufs, peak = loudness(path)
    drift = abs(float(video["duration"]) - float(audio["duration"])) if audio else None
    checks = [
        ("size 1080x1920", (video["width"], video["height"]) == EXPECTED_SIZE, f"{video['width']}x{video['height']}"),
        ("fps 30", video["r_frame_rate"] == EXPECTED_FPS, video["r_frame_rate"]),
        (f"duration < {MAX_DURATION:.0f}s", duration < MAX_DURATION, f"{duration:.2f}s"),
        ("audio stream present", audio is not None, "yes" if audio else "no"),
        (f"A/V drift <= {AV_DRIFT_MAX}s", drift is not None and drift <= AV_DRIFT_MAX,
         f"{drift:.3f}s" if drift is not None else "n/a"),
        (f"loudness {LUFS_TARGET:.0f}±{LUFS_TOLERANCE:.0f} LUFS", abs(lufs - LUFS_TARGET) <= LUFS_TOLERANCE, f"{lufs} LUFS"),
        (f"true peak <= {PEAK_MAX} dBFS", peak <= PEAK_MAX, f"{peak} dBFS"),
    ]
    for name, ok, observed in checks:
        print(f"{'PASS' if ok else 'FAIL'}  {name}: {observed}")
    out = Path(sheet) if sheet else Path("/tmp") / f"{path.stem}-contact-sheet.jpg"
    times = contact_sheet(path, duration, out)
    print(f"contact sheet ({', '.join(f'{t:.1f}s' for t in times)}): {out}")
    return all(ok for _, ok, _ in checks)


if __name__ == "__main__":
    if len(sys.argv) not in (2, 3):
        sys.exit(__doc__)
    sys.exit(0 if main(*sys.argv[1:]) else 1)
