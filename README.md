<p align="center">
  <h1 align="center">🐳 ds4-three-way — Local AI vs Cloud, Same Prompt, One MacBook</h1>
  <p align="center">
    <strong>The day Antirez shipped <a href="https://github.com/antirez/ds4"><code>ds4</code></a>, I gave the same prompt to three different AI engines on the same 128 GB MacBook Pro.<br>Local DeepSeek V4 Flash beat cloud Claude on wall-clock time.</strong>
  </p>
  <p align="center">
    <a href="https://youtu.be/7l8-s8xkpms" target="_blank">
      <img src="https://img.youtube.com/vi/7l8-s8xkpms/maxresdefault.jpg" alt="Watch the three-way comparison on YouTube" width="720">
    </a>
    <br>
    <em>▶ Watch on YouTube — three engines, three completely different auroras</em>
  </p>
  <p align="center">
    <em>Built by <a href="https://x.com/NiceDreamzApps">Matt Macosko</a> · companion to <a href="https://github.com/nicedreamzapp/claude-code-local">claude-code-local</a></em>
  </p>
</p>

---

## The benchmark

One identical prompt sent to three different inference stacks on the same MacBook:

> *"Build a complete single-file HTML page with an animated northern lights scene using vanilla JavaScript and inline CSS — wide canvas, deep starfield with subtle twinkling, mountain silhouette with jagged peaks, pine tree silhouettes along the ridges, brilliant flowing aurora bands shifting between green, teal, magenta, and violet, animating smoothly forever; the mountains and trees should pick up a subtle colored glow from the aurora overhead."*

| Engine | Time | Output | Hosted on |
|---|---:|---:|---|
| 🐳 **DeepSeek V4 Flash** (`ds4` local) | **103 s** | 3,259 tokens | Apple Silicon GPU |
| ☁️ **Cloud Claude** (Max plan) | **192 s** | ~3,500 tokens | Anthropic data center |
| 🟢 **Gemma 4 31B** (MLX local) | **131 s** | 1,992 tokens | Apple Silicon GPU |

Each one produced a completely different aurora. None of the local outputs left the laptop.

---

## What's in this repo

```
ds4-comparison-video/
├── README.md                                this file
├── run_benchmark.sh                         hits all 3 backends with the same prompt
├── narration.txt                            the voiceover script
├── outputs/
│   ├── ds4.html              → DeepSeek's interpretation
│   ├── cloud-claude.html     → Cloud Claude's interpretation
│   └── gemma.html            → Gemma's interpretation
├── comparison.html                          three-up iframe page used in the video
├── scene-{ds4,cloud-claude,gemma}.html      single-engine showcase pages
├── title.html / outro.html                  title and outro cards
├── recordings/                              captured PNGs + MP4 segments
└── ds4-comparison-final.mp4                 the finished 52-second video
```

---

## Reproduce it

```sh
# 1. Boot the local servers (each idempotent)
~/.local/bin/ds4-server-up        # DeepSeek V4 Flash on :8000
~/.local/bin/mlx-server-up        # Gemma 4 31B on :4000

# 2. Run the benchmark — saves outputs/{ds4,gemma,cloud-claude}.html
bash run_benchmark.sh

# 3. Open the live three-up comparison in your browser
open comparison.html
```

For Cloud Claude, the script shells out to `claude --print` so it uses your Max-plan subscription instead of API credits.

---

## Why each engine produced what it produced

- **`ds4` / DeepSeek V4 Flash** went pine-forest with a flowing teal/lavender ribbon aurora. Most cohesive of the three. The mountains read as a dense tree silhouette, not a peak-line — coherent interpretation of "mountain ridges with pine trees along them."
- **Cloud Claude / Sonnet** went the most cinematic — vivid magenta + teal aurora bands draped across jagged mountain silhouettes, with subtle luminescent dusting along the peaks.
- **Gemma 4 31B** went minimalist — a clean line-drawing mountain silhouette under a single sweeping streak of green and violet. Stylized, almost graphic.

Three completely different aesthetic interpretations of one prompt, on the same hardware. The model is the lens.

---

## Reading list (companion writing)

- 📰 [Headline article — *I Just Watched One Hacker Catch Up to a Trillion-Dollar Data Center*](https://marijuanaunion.com/i-just-watched-one-hacker-catch-up-to-a-trillion-dollar-data-center/)
- 🔧 [Technical deep-dive — *The Day Local AI Caught the Cloud: ds4, DeepSeek V4 Flash, and What Just Changed for Devs*](https://nicedreamzwholesale.com) *(coming this week)*
- 📺 [Companion video on YouTube](https://youtu.be/7l8-s8xkpms)
- 🐳 [`antirez/ds4`](https://github.com/antirez/ds4) — the engine
- 🤗 [`antirez/deepseek-v4-gguf`](https://huggingface.co/antirez/deepseek-v4-gguf) — the GGUFs
- 🥊 [`nicedreamzapp/claude-code-local`](https://github.com/nicedreamzapp/claude-code-local) — the lineup that DS4 just joined

---

## License

MIT. Output HTML files are AI-generated and reflect each respective model's license.

May 9, 2026.
