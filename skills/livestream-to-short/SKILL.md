---
name: livestream-to-short
description: Turn one of the owner's YouTube livestreams into a vertical 9:16 Short under 60 s — download 1080p with yt-dlp, transcribe with whisper.cpp, rank topics from transcript + live chat, then cut, zoom into screen regions, stack the facecam below, burn captions and loudness-normalise with ffmpeg. Use whenever the owner pastes a YouTube live/video link and wants a Short, clip or highlight from it ("làm short từ live này", "cắt short", "dựng video short dọc", "tải livestream 1080p rồi phân tích", "make a short from my stream"), or asks to redo/tweak a Short built this way. Stops for topic choice and never uploads.
---

# Livestream → Short

One livestream in, one checked 1080×1920 MP4 out. The renderer is config-driven: per Short you write one
`short.json` (clip, jump cuts, zoom regions, shots, header, captions) and the scripts do the rest.
`assets/short.example.json` is a finished Short (Day 46, "API cost"), so copy it rather than starting blank.

Scripts live in `~/.claude/skills/livestream-to-short/scripts/` (`$S` below). Run Python with `-I`.

## Hard stops

- **Cookies:** ask which browser before passing `--cookies-from-browser`. Reading cookies is the owner's call.
- **Topic:** after proposing topics, stop and wait for the owner's pick, unless they already named one.
- **Upload:** never upload or publish. Deliver the file and wait for the owner to approve it by eye.
- **Temp files:** wav, frames, stems and sheets go in `/tmp/<slug>-work/`, never inside the project.

## Project layout

```
<project>/source/<slug>-source-1080p.mp4      source/chat/<slug>.live_chat.json
<project>/analysis/<slug>-transcript.{srt,json}
<project>/shorts/<topic-slug>/short.json       captions.ass (generated)   <topic-slug>.mp4
```

Re-renders overwrite `<topic-slug>.mp4`. Don't create `-v2` / `-final` copies.

## 0. Preflight

Check the tools with `which yt-dlp ffmpeg ffprobe whisper-cli demucs`. The models live in `~/.local/share/whisper-cpp/models/`.

| Missing | Install |
|---|---|
| `yt-dlp`, `ffmpeg`, `whisper-cli` | `brew install yt-dlp ffmpeg whisper-cpp` |
| `demucs` | `uv tool install --python 3.11 demucs --with torch==2.5.1 --with torchaudio==2.5.1 --with soundfile` |
| `ggml-large-v3-turbo.bin` | whisper.cpp's `models/download-ggml-model.sh large-v3-turbo` |
| `ggml-silero-v5.1.2.bin` | `curl -sSLfo ggml-silero-v5.1.2.bin https://huggingface.co/ggml-org/whisper-vad/resolve/main/ggml-silero-v5.1.2.bin` |

## 1. Download

1. Check the metadata first: `yt-dlp --no-warnings -J <url>` gives the title, duration and live_status.
2. Download the video and the chat:

```bash
yt-dlp -f "137+140/bv*[height<=1080][vcodec^=avc1]+ba[ext=m4a]/bv*[height<=1080]+ba" \
  --merge-output-format mp4 -o "<slug>-source-1080p.%(ext)s" <url>
yt-dlp --write-subs --sub-langs live_chat --skip-download -o "chat/<slug>" <url>
```

"Sign in to confirm you're not a bot" or HTTP 429 means anonymous clients are blocked. Switching
`player_client` returns only storyboards, so ask for cookies and add `--cookies-from-browser <browser>`.

## 2. Transcribe

```bash
ffmpeg -v error -y -i source/<slug>-source-1080p.mp4 -vn -ac 1 -ar 16000 -c:a pcm_s16le /tmp/<slug>-work/audio.wav
whisper-cli -m ~/.local/share/whisper-cpp/models/ggml-large-v3-turbo.bin \
  -vm ~/.local/share/whisper-cpp/models/ggml-silero-v5.1.2.bin --vad -mc 0 -l vi -t 8 -np \
  -osrt -oj -of analysis/<slug>-transcript -f /tmp/<slug>-work/audio.wav
```

- **VAD and `-mc 0` are what make it usable.** Without them whisper fills silence with invented lines
  ("hãy subscribe cho kênh…") and then repeats them for the rest of the file. Spot-check for repeats before trusting it.
- **Run it in the background.** A 2–3 h stream takes a while.

## 3. Analyse and propose topics

- `python3 -I $S/compact-transcript.py analysis/<slug>-transcript.json` gives ~20 s lines to read the whole stream.
- `python3 -I $S/chat-density.py source/chat/<slug>.live_chat.json` gives the busiest chat minutes and every message.
- `python3 -I $S/transcript-range.py <transcript.json> <start> <end> [...]` gives exact segments for a window.

Propose 4–6 topics, each with:
- the timestamp range,
- a one-line hook,
- why it works as a Short,
- the risks: background music (Content ID), and claims you can't verify.

Recommend one. Under 60 s, a single topic beats a recap of the whole stream. Then stop.

## 4. Build the Short

1. **Pick the clip.**
   - Set `clip_origin` a second or two before the first kept word.
   - Keep `clip_len` at 60 s or less of raw source.
2. **Measure, don't guess.**
   - Extract frames across the clip (`ffmpeg -ss <t> -i src -frames:v 1 x.png`) and look at them.
   - Crop candidate boxes at native size to confirm the facecam box, the screen regions you'll zoom into, and any OBS overlay to keep out of crops.
   - Sample the app background for `bg_color`: `-vf "crop=1:1:x:y,format=rgb24" -f rawvideo - | xxd -p`.
3. **Write the config.** Copy `assets/short.example.json` to `shorts/<topic-slug>/short.json`. Coordinates are in the 1920×1080 source.
   - `regions`: named source boxes.
   - `shots`: `[start, end, region]` on the output timeline. Change regions when the speaker's subject changes.
   - `screen_area` / `cam_area`: output boxes. Screen goes on top, facecam at the bottom.
   - `masks` (optional): `[x, y, w, h]` source boxes painted `bg_color`, for a wide crop that can't avoid the facecam or an OBS overlay.
   - `target_lufs` + `audio_pre` (optional): a louder mix than −14 LUFS, e.g. `-10` with a compressor; pass the same target as `check-short.py`'s third argument.
   - `labels` (optional): `[start, end, x, y, text]` yellow tags in output coordinates, to point at parts of the screen.
4. **Prepare the audio.** Run `python3 -I $S/render-short.py prepare short.json`.
   - It extracts the clip and runs Demucs, then prints the mean level of each stem.
   - `"audio": "vocals"` is the default and strips music for Content ID.
   - Use `"original"` only if the vocals stem sounds watery and `no_vocals` is near silent (about −40 dB or quieter).
5. **Jump cuts.** Find pauses with `ffmpeg -i <work>/sep/htdemucs/clip_raw/vocals.wav -af silencedetect=n=-35dB:d=0.25 -f null -`.
   - Set `keep` as `[start, end]` relative to `clip_origin`.
   - Cut inside pauses, never mid-word.
   - The script snaps cuts to frames and adds 20 ms fades.
6. **Captions.** Run `python3 -I $S/render-short.py words short.json` to get word timings on the cut timeline. Write `captions` as `[start, end, text]`:
   - 2–5 words each.
   - Fix whisper's mishearings, e.g. "API code" → "API cost".
   - Wrap key terms in `*…*` to colour them yellow.
   - The header (`Title` + 1–2 `Sub` lines) carries the hook for the whole video.
7. **Render.** Run `python3 -I $S/render-short.py video short.json`. It writes `captions.ass`, then the MP4.
8. **Check.** Run `python3 -I $S/check-short.py <topic-slug>.mp4 /tmp/<slug>-work/sheet.jpg`. Every line must PASS. Then open the sheet and look at it:
   - Vietnamese diacritics render correctly.
   - The correct region is on screen for each line.
   - No overlay leaks into a crop.
   - Captions stay clear of the face, the right-hand Shorts button column and the bottom UI band.
   - Fix the config and render again.

## 5. Deliver

- Open the file with `open -a "QuickTime Player" <file>`. Preview.app can't play mp4. Send it with SendUserFile if that tool is available.
- Report what the checks proved and what they didn't. Listening for A/V sync at the cuts is still the owner's job.
- Offer concrete tweaks: header text, region timing, facecam crop. Wait for eye-approval.

## Traps

- **Fonts:** libass on macOS matches PostScript names (`SFProDisplay-Heavy`). A full name like "SF Pro Display Heavy" silently renders in regular weight. The styles in `render-short.py` already use PostScript names.
- **Paths:** the renderer runs ffmpeg from the config's folder so `ass=captions.ass` needs no escaping. Don't pass absolute paths containing `:` or `'` into a filtergraph yourself.
- **zsh:** `set -- $var` doesn't word-split in zsh. Write loops with explicit values.
- **Numbers on screen:** a figure must match its on-screen context. A total under an "All" tab is not "/tháng", even if the speaker says so. Keep claims you can't verify out of the header.
- **Sensitive content:** before including a moment, check whether the speaker or chat reveals personal info, keys or private dashboards.
