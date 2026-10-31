"""Render a 9:16 Short from a livestream clip, driven by one short.json config.

Usage (paths inside the config are relative to the config file):
  python3 -I render-short.py prepare  short.json  -> clip audio + Demucs vocals stem in work_dir
  python3 -I render-short.py words    short.json  -> word timings on the CUT timeline, for captions
  python3 -I render-short.py captions short.json  -> writes captions.ass next to the config
  python3 -I render-short.py video    short.json  -> writes captions.ass, then the final MP4

Layout (1080x1920): header text on top, the zoomed screen region in the middle,
the facecam at the bottom, captions burned in. See assets/short.example.json.
"""
import json
import re
import subprocess
import sys
from pathlib import Path

FPS = 30
OUT_W, OUT_H = 1080, 1920
TARGET_LUFS = -14
TRUE_PEAK = -1.5
FADE_SEC = 0.02  # tiny audio fade at every jump cut to avoid clicks
FONTS_DIR = "/Library/Fonts"
CAPTIONS_FILE = "captions.ass"
MODELS_DIR = Path.home() / ".local/share/whisper-cpp/models"
WHISPER_MODEL = MODELS_DIR / "ggml-large-v3-turbo.bin"
DTW_PRESET = "large.v3.turbo"  # must match WHISPER_MODEL
DEFAULT_CAPTION_Y = 1200
KEYWORD_COLOR = "&H000AD6FF&"  # ASS is BGR: this is yellow
TEXT_COLOR = "&H00FFFFFF&"
CAPTION_POP = r"\fscx85\fscy85\t(0,80,\fscx100\fscy100)"

# libass on macOS matches PostScript names; a full name like "SF Pro Display Heavy"
# silently falls back to the regular weight.
ASS_HEADER = f"""[Script Info]
ScriptType: v4.00+
PlayResX: {OUT_W}
PlayResY: {OUT_H}
WrapStyle: 0
ScaledBorderAndShadow: yes

[V4+ Styles]
Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding
Style: Title,SFProDisplay-Heavy,80,&H00FFFFFF,&H00FFFFFF,&H00000000,&H00000000,0,0,0,0,100,100,0,0,1,0,0,8,40,40,0,1
Style: Sub,SFProDisplay-Bold,50,&H000AD6FF,&H000AD6FF,&H00000000,&H00000000,0,0,0,0,100,100,0,0,1,0,0,8,40,40,0,1
Style: Cap,SFProDisplay-Heavy,68,&H00FFFFFF,&H00FFFFFF,&H00000000,&H96000000,0,0,0,0,100,100,0,0,1,7,3,5,60,60,0,1
Style: Label,SFProDisplay-Heavy,44,&H00000000,&H00000000,&H000AD6FF,&H00000000,0,0,0,0,100,100,0,0,3,10,0,5,0,0,0,1

[Events]
Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text
"""


def load_config(path):
    path = Path(path).resolve()
    cfg = json.loads(path.read_text(encoding="utf-8"))
    base = path.parent
    work = Path(cfg["work_dir"]).expanduser()
    return {
        **cfg,
        "dir": base,
        "source": (base / cfg["source"]).resolve(),
        "output": base / cfg["output"],
        "work_dir": work,
        "clip_raw": work / "clip_raw.wav",
        "vocals": work / "sep" / "htdemucs" / "clip_raw" / "vocals.wav",
        "no_vocals": work / "sep" / "htdemucs" / "clip_raw" / "no_vocals.wav",
    }


def run(cmd, cwd=None):
    print(" ".join(str(c) for c in cmd[:6]), "...", file=sys.stderr)
    result = subprocess.run([str(c) for c in cmd], cwd=cwd, capture_output=True, text=True)
    if result.returncode != 0:
        sys.exit(f"command failed ({result.returncode}): {cmd[0]}\n{result.stderr[-2000:]}")
    return result


def snap(sec):
    return round(round(sec * FPS) / FPS, 4)


def keep_segments(cfg):
    return [(snap(a), snap(b)) for a, b in cfg["keep"]]


def total_duration(cfg):
    return sum(b - a for a, b in keep_segments(cfg))


def audio_input(cfg):
    """ffmpeg input args for the clip audio; trim times are relative to clip_origin either way."""
    if cfg.get("audio", "vocals") == "vocals":
        if not cfg["vocals"].exists():
            sys.exit(f"missing {cfg['vocals']} - run `prepare` first")
        return ["-i", cfg["vocals"]]
    return ["-ss", str(cfg["clip_origin"]), "-t", str(cfg["clip_len"]), "-i", cfg["source"]]


def audio_cut_filter(cfg, label_in, label_out):
    parts, labels = [], []
    for i, (a, b) in enumerate(keep_segments(cfg)):
        dur = b - a
        parts.append(
            f"[{label_in}]atrim={a}:{b},asetpts=PTS-STARTPTS,"
            f"afade=t=in:d={FADE_SEC},afade=t=out:st={dur - FADE_SEC:.3f}:d={FADE_SEC}[a{i}]"
        )
        labels.append(f"[a{i}]")
    parts.append(f"{''.join(labels)}concat=n={len(labels)}:v=0:a=1[{label_out}]")
    return parts


def mean_volume(path):
    stderr = run(["ffmpeg", "-hide_banner", "-i", path, "-af", "volumedetect", "-f", "null", "-"]).stderr
    match = re.search(r"mean_volume: (-?[\d.]+) dB", stderr)
    return float(match.group(1)) if match else None


def prepare(cfg):
    cfg["work_dir"].mkdir(parents=True, exist_ok=True)
    run(["ffmpeg", "-v", "error", "-y", "-ss", str(cfg["clip_origin"]), "-t", str(cfg["clip_len"]),
         "-i", cfg["source"], "-vn", "-c:a", "pcm_s16le", cfg["clip_raw"]])
    # MPS fails with "Output channels > 65536 not supported", so Demucs runs on the CPU.
    run(["demucs", "-d", "cpu", "--two-stems=vocals", "-n", "htdemucs",
         "-o", cfg["work_dir"] / "sep", cfg["clip_raw"]])
    for name in ("clip_raw", "vocals", "no_vocals"):
        print(f"{name}: mean {mean_volume(cfg[name])} dB  ({cfg[name]})")


def words(cfg):
    cut = cfg["work_dir"] / "cut_audio.wav"
    stem = cfg["work_dir"] / "cut_words"
    graph = ";".join(audio_cut_filter(cfg, "0:a", "aout"))
    run(["ffmpeg", "-v", "error", "-y", *audio_input(cfg), "-filter_complex", graph,
         "-map", "[aout]", "-ar", "16000", "-ac", "1", cut])
    run(["whisper-cli", "-m", WHISPER_MODEL, "-l", cfg.get("language", "vi"), "-np",
         "-ml", "1", "-sow", "-dtw", DTW_PRESET, "-mc", "0", "-oj", "-of", stem, "-f", cut])
    segments = json.loads(Path(f"{stem}.json").read_text(encoding="utf-8"))["transcription"]
    for seg in segments:
        text = seg["text"].strip()
        if text:
            print(f"{seg['offsets']['from'] / 1000:6.2f}-{seg['offsets']['to'] / 1000:6.2f} {text}")
    print(f"cut timeline total: {total_duration(cfg):.2f}s", file=sys.stderr)


def ass_time(sec):
    cs = round(sec * 100)
    h, rest = divmod(cs, 360000)
    m, rest = divmod(rest, 6000)
    s, c = divmod(rest, 100)
    return f"{h}:{m:02d}:{s:02d}.{c:02d}"


def ass_text(text):
    """`*keyword*` -> yellow. Literal braces would open an ASS override block, so swap them."""
    parts = text.replace("{", "(").replace("}", ")").split("*")
    if len(parts) % 2 == 0:
        sys.exit(f"unbalanced *keyword* markup: {text}")
    return "".join(
        f"{{\\c{KEYWORD_COLOR}}}{part}{{\\c{TEXT_COLOR}}}" if i % 2 else part
        for i, part in enumerate(parts)
    )


def write_captions(cfg):
    end = ass_time(total_duration(cfg))
    caption_y = cfg.get("caption_y", DEFAULT_CAPTION_Y)
    lines = [
        f"Dialogue: 1,0:00:00.00,{end},{h['style']},,0,0,0,,{{\\pos({OUT_W // 2},{h['y']})}}{ass_text(h['text'])}"
        for h in cfg.get("header", [])
    ] + [
        f"Dialogue: 0,{ass_time(s)},{ass_time(e)},Cap,,0,0,0,,"
        f"{{\\pos({OUT_W // 2},{caption_y}){CAPTION_POP}}}{ass_text(text)}"
        for s, e, text in cfg.get("captions", [])
    ] + [
        f"Dialogue: 2,{ass_time(s)},{ass_time(e)},Label,,0,0,0,,{{\\pos({x},{y}){CAPTION_POP}}}{ass_text(text)}"
        for s, e, x, y, text in cfg.get("labels", [])
    ]
    out = cfg["dir"] / CAPTIONS_FILE
    out.write_text(ASS_HEADER + "\n".join(lines) + "\n", encoding="utf-8")
    print(out)


def loudnorm_args(cfg):
    """Optional `audio_pre` filter (e.g. a compressor), then loudnorm towards `target_lufs`."""
    pre = cfg.get("audio_pre")
    return (f"{pre}," if pre else "") + f"loudnorm=I={cfg.get('target_lufs', TARGET_LUFS)}:TP={TRUE_PEAK}:LRA=11"


def measure_loudness(cfg):
    graph = ";".join(audio_cut_filter(cfg, "0:a", "aout"))
    stderr = run(["ffmpeg", "-hide_banner", *audio_input(cfg), "-filter_complex",
                  graph + f";[aout]{loudnorm_args(cfg)}:print_format=json[m]",
                  "-map", "[m]", "-f", "null", "-"]).stderr
    # loudnorm prints its JSON after other log lines; slice to the last brace.
    return json.loads(stderr[stderr.rindex("{"):stderr.rindex("}") + 1])


def fit_region(cfg, name, label_in, label_out):
    """Crop a source region, scale it to fit the screen area, pad with the background colour."""
    x, y, w, h = cfg["regions"][name]
    _, _, area_w, area_h = cfg["screen_area"]
    scale = min(area_w / w, area_h / h)
    # Masks paint over source pixels (e.g. the facecam and an OBS overlay inside a wide crop); the cam crop is untouched.
    masks = "".join(f"drawbox={mx}:{my}:{mw}:{mh}:color={cfg['bg_color']}:t=fill,"
                    for mx, my, mw, mh in cfg.get("masks", []))
    sw, sh = round(w * scale / 2) * 2, round(h * scale / 2) * 2
    return (
        f"[{label_in}]{masks}crop={w}:{h}:{x}:{y},scale={sw}:{sh}:flags=lanczos,unsharp=5:5:0.5,"
        f"pad={area_w}:{area_h}:(ow-iw)/2:(oh-ih)/2:color={cfg['bg_color']}[{label_out}]"
    )


def video_graph(cfg, audio_label, loud):
    segments = keep_segments(cfg)
    total = total_duration(cfg)
    shots = cfg["shots"]
    parts = [f"[0:v]trim={a}:{b},setpts=PTS-STARTPTS[v{i}]" for i, (a, b) in enumerate(segments)]
    parts.append("".join(f"[v{i}]" for i in range(len(segments)))
                 + f"concat=n={len(segments)}:v=1:a=0,fps={FPS}[vcut]")

    used = sorted({name for _, _, name in shots})
    parts.append(f"[vcut]split={len(used) + 1}[cam_src]" + "".join(f"[{n}_src]" for n in used))
    cx, cy, cw, ch = cfg["cam_box"]
    cam_x, cam_y, cam_w, cam_h = cfg["cam_area"]
    # Cover-scale then centre-crop, so a cam box with a slightly different aspect never stretches.
    parts.append(f"[cam_src]crop={cw}:{ch}:{cx}:{cy},scale={cam_w}:{cam_h}:"
                 f"force_original_aspect_ratio=increase:flags=lanczos,crop={cam_w}:{cam_h}[cam]")
    parts.extend(fit_region(cfg, name, f"{name}_src", name) for name in used)

    parts.append(f"color=c={cfg['bg_color']}:s={OUT_W}x{OUT_H}:r={FPS}:d={total:.3f}[base]")
    screen_x, screen_y = cfg["screen_area"][:2]
    current = "base"
    for idx, name in enumerate(used):
        windows = "+".join(f"between(t,{s},{min(e, total)})" for s, e, n in shots if n == name)
        parts.append(f"[{current}][{name}]overlay={screen_x}:{screen_y}:enable='{windows}':shortest=1[s{idx}]")
        current = f"s{idx}"
    parts.append(f"[{current}][cam]overlay={cam_x}:{cam_y}:shortest=1[comp]")
    # ffmpeg runs with cwd = the config folder, so the ass path needs no filtergraph escaping.
    parts.append(f"[comp]ass={CAPTIONS_FILE}:fontsdir={FONTS_DIR},format=yuv420p[vout]")

    audio = audio_cut_filter(cfg, audio_label, "acut")
    parts.extend(audio)
    parts.append(
        f"[acut]{loudnorm_args(cfg)}:measured_I={loud['input_i']}:"
        f"measured_TP={loud['input_tp']}:measured_LRA={loud['input_lra']}:"
        f"measured_thresh={loud['input_thresh']}:offset={loud['target_offset']}:linear=true,"
        f"aresample=48000[aout]"
    )
    return ";".join(parts)


def video(cfg):
    write_captions(cfg)
    loud = measure_loudness(cfg)
    video_in = ["-ss", str(cfg["clip_origin"]), "-i", cfg["source"]]
    uses_vocals = cfg.get("audio", "vocals") == "vocals"
    inputs = [*video_in, *audio_input(cfg)] if uses_vocals else video_in
    audio_label = "1:a" if uses_vocals else "0:a"
    total = total_duration(cfg)
    run([
        "ffmpeg", "-v", "error", "-y", *inputs,
        "-filter_complex", video_graph(cfg, audio_label, loud),
        "-map", "[vout]", "-map", "[aout]",
        "-c:v", "libx264", "-preset", "slow", "-crf", "18", "-r", str(FPS),
        "-c:a", "aac", "-b:a", "192k", "-ac", "2",
        "-movflags", "+faststart", "-t", f"{total:.3f}", cfg["output"],
    ], cwd=cfg["dir"])
    print(cfg["output"])


COMMANDS = {"prepare": prepare, "words": words, "captions": write_captions, "video": video}

if __name__ == "__main__":
    if len(sys.argv) != 3 or sys.argv[1] not in COMMANDS:
        sys.exit(f"usage: render-short.py {{{'|'.join(COMMANDS)}}} short.json")
    COMMANDS[sys.argv[1]](load_config(sys.argv[2]))
