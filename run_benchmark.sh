#!/bin/bash
# run_benchmark.sh — run the same prompt against ds4 (local), Gemma (local
# MLX), and cloud Claude. Times each, saves outputs side-by-side.

set -uo pipefail

OUT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/outputs"
mkdir -p "$OUT_DIR"

PROMPT="${1:-Write a complete single-file HTML page with a playable Snake game. Use vanilla JavaScript and inline CSS — no external libraries. Include arrow-key controls, a score counter, smooth movement on a 25x25 grid, food that respawns, a game-over overlay with a Restart button, and a black background with a green snake. Output ONLY the HTML, starting with <!doctype html>, no commentary.}"

echo "=== Benchmark prompt ==="
echo "$PROMPT"
echo

run_ds4() {
    local out="$OUT_DIR/ds4.html"
    local meta="$OUT_DIR/ds4.meta.txt"
    echo "[ds4] starting..."
    local t0=$(date +%s)
    local body
    body=$(jq -n --arg p "$PROMPT" '{
        model:"deepseek-v4-flash",
        max_tokens:8000,
        temperature:0.2,
        thinking:{type:"disabled"},
        messages:[{role:"user",content:$p}]
    }')
    curl -s -X POST http://127.0.0.1:8000/v1/messages \
        -H 'Content-Type: application/json' \
        -H 'anthropic-version: 2023-06-01' \
        -d "$body" > "$OUT_DIR/ds4.raw.json"
    local t1=$(date +%s)
    jq -r '.content[0].text // .choices[0].message.content // ""' "$OUT_DIR/ds4.raw.json" > "$out"
    echo "elapsed_seconds=$((t1 - t0))" > "$meta"
    echo "model=DeepSeek V4 Flash (ds4 local)" >> "$meta"
    jq -r '.usage // empty' "$OUT_DIR/ds4.raw.json" >> "$meta"
    echo "[ds4] $(wc -l < "$out") lines, $((t1 - t0))s"
}

run_gemma() {
    local out="$OUT_DIR/gemma.html"
    local meta="$OUT_DIR/gemma.meta.txt"
    echo "[gemma] starting..."
    local t0=$(date +%s)
    local body
    body=$(jq -n --arg p "$PROMPT" '{
        model:"gemma-4-31b",
        max_tokens:8000,
        messages:[{role:"user",content:$p}]
    }')
    curl -s -X POST http://127.0.0.1:4000/v1/messages \
        -H 'Content-Type: application/json' \
        -H 'anthropic-version: 2023-06-01' \
        -d "$body" > "$OUT_DIR/gemma.raw.json"
    local t1=$(date +%s)
    jq -r '.content[0].text // ""' "$OUT_DIR/gemma.raw.json" > "$out"
    echo "elapsed_seconds=$((t1 - t0))" > "$meta"
    echo "model=Gemma 4 31B (MLX local)" >> "$meta"
    jq -r '.usage // empty' "$OUT_DIR/gemma.raw.json" >> "$meta"
    echo "[gemma] $(wc -l < "$out") lines, $((t1 - t0))s"
}

run_cloud_claude() {
    local out="$OUT_DIR/cloud-claude.html"
    local meta="$OUT_DIR/cloud-claude.meta.txt"
    echo "[cloud-claude] starting..."
    local t0=$(date +%s)
    # claude CLI in print mode — uses the user's Max-plan oauth.
    claude --print "$PROMPT" > "$out" 2>/dev/null
    local t1=$(date +%s)
    echo "elapsed_seconds=$((t1 - t0))" > "$meta"
    echo "model=Cloud Claude (claude CLI, Max plan)" >> "$meta"
    echo "[cloud-claude] $(wc -l < "$out") lines, $((t1 - t0))s"
}

case "${MODE:-all}" in
    ds4)    run_ds4 ;;
    gemma)  run_gemma ;;
    cloud)  run_cloud_claude ;;
    all)
        run_ds4
        run_gemma
        run_cloud_claude
        ;;
esac

echo
echo "=== Done. Outputs in $OUT_DIR ==="
ls -la "$OUT_DIR"
