#!/bin/bash
# Test ElevenLabs TTS from devcontainer
# Requires ELEVEN_API_KEY in .env
#
# Usage:
#   ./test-elevenlabs.sh --list              # List available voices
#   ./test-elevenlabs.sh                     # Test with default voice
#   ./test-elevenlabs.sh "Custom text"       # Test with custom text
#   ./test-elevenlabs.sh "Text" voice_id     # Test with specific voice

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Load .env
if [ -f "$PROJECT_DIR/.env" ]; then
    export $(grep -v '^#' "$PROJECT_DIR/.env" | xargs)
fi

if [ -z "$ELEVEN_API_KEY" ]; then
    echo "Error: ELEVEN_API_KEY not set. Add it to .env"
    exit 1
fi

# Handle --list flag
if [ "$1" = "--list" ]; then
    echo "=== Available ElevenLabs Voices ==="
    python3 << 'PYEOF'
import os
from elevenlabs.client import ElevenLabs

client = ElevenLabs(api_key=os.environ["ELEVEN_API_KEY"])
voices = client.voices.get_all()

print(f"\nFound {len(voices.voices)} voices:\n")
print(f"{'Name':<30} {'Voice ID':<25} {'Labels'}")
print("-" * 80)

for voice in sorted(voices.voices, key=lambda v: v.name):
    labels = ""
    if voice.labels:
        labels = ", ".join(f"{k}:{v}" for k, v in list(voice.labels.items())[:3])
    print(f"{voice.name:<30} {voice.voice_id:<25} {labels[:30]}")
PYEOF
    exit 0
fi

# Default text and voice
TEXT="${1:-Hello! This is ElevenLabs text to speech with Daniel, the steady broadcaster. The audio quality should be excellent, with natural intonation and expression.}"
VOICE_ID="${2:-onwK4e9ZLuTAKqWW03F9}"  # Daniel - Steady Broadcaster

echo "=== ElevenLabs TTS Test ==="
echo "Voice: Daniel - Steady Broadcaster"
echo "Voice ID: $VOICE_ID"
echo "Text: $TEXT"
echo ""

python3 << PYEOF
import os
import time
import subprocess
import tempfile
from elevenlabs.client import ElevenLabs

client = ElevenLabs(api_key=os.environ["ELEVEN_API_KEY"])

print("Generating audio...")
start = time.time()

audio = client.text_to_speech.convert(
    text="""$TEXT""",
    voice_id="$VOICE_ID",
    model_id="eleven_multilingual_v2",
    output_format="mp3_44100_128"
)

# Save to temp file
with tempfile.NamedTemporaryFile(suffix=".mp3", delete=False) as f:
    for chunk in audio:
        f.write(chunk)
    temp_path = f.name

gen_time = time.time() - start
print(f"Generated in {gen_time:.2f}s")
print("")
print("Playing audio via PulseAudio...")

# Convert mp3 to wav and play via paplay
wav_path = temp_path.replace(".mp3", ".wav")
subprocess.run(
    ["ffmpeg", "-y", "-i", temp_path, "-ar", "44100", wav_path],
    check=True, capture_output=True
)
subprocess.run(["paplay", wav_path], check=True)

import os as os_module
os_module.unlink(temp_path)
os_module.unlink(wav_path)
print("Done!")
PYEOF
