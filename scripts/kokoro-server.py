#!/usr/bin/env python3
"""
Kokoro TTS Server - Run on Mac host
Terminal UI with real-time status and history.

Usage:
    python kokoro-server.py /path/to/claudio
"""

import argparse
import os
import sys
import time
import threading
from datetime import datetime
from pathlib import Path
from collections import deque

# Config
KOKORO_DIR = Path.home() / ".kokoro"
DEFAULT_VOICE = "bm_george"
DEFAULT_LANG = "en-gb"

# State
history = deque(maxlen=10)
status = {"ready": False, "speaking": False, "total": 0, "voice": DEFAULT_VOICE}
kokoro = None
lock = threading.Lock()


def init_kokoro():
    """Initialize Kokoro TTS engine."""
    global kokoro, status

    model_path = KOKORO_DIR / "kokoro-v1.0.onnx"
    voices_path = KOKORO_DIR / "voices-v1.0.bin"

    if not model_path.exists():
        print(f"❌ Model not found at {model_path}")
        print("   Run setup-kokoro.sh first")
        sys.exit(1)

    try:
        # Import should work if venv is activated by shell script
        from kokoro_onnx import Kokoro
        os.chdir(KOKORO_DIR)
        kokoro = Kokoro(str(model_path), str(voices_path))
        status["ready"] = True
        return True
    except ImportError as e:
        print(f"❌ Module not found: {e}")
        print("   Make sure to run via kokoro-server.sh (activates venv)")
        print("   Or run: source ~/.kokoro/venv/bin/activate")
        return False
    except Exception as e:
        print(f"❌ Failed to init Kokoro: {e}")
        return False


def speak(text, voice=None):
    """Speak text using Kokoro."""
    global status

    if not kokoro or not text.strip():
        return

    voice = voice or status["voice"]

    try:
        import sounddevice as sd

        with lock:
            status["speaking"] = True

        start = time.time()
        samples, sample_rate = kokoro.create(text, voice=voice, speed=1.0, lang=DEFAULT_LANG)
        gen_time = time.time() - start
        audio_duration = len(samples) / sample_rate

        sd.play(samples, sample_rate)
        sd.wait()

        with lock:
            history.append({
                "time": datetime.now().strftime("%H:%M:%S"),
                "text": text[:60] + ("..." if len(text) > 60 else ""),
                "gen": f"{gen_time:.2f}s",
                "dur": f"{audio_duration:.1f}s"
            })
            status["total"] += 1
            status["speaking"] = False

    except Exception as e:
        with lock:
            status["speaking"] = False
        print(f"\r❌ Error: {e}")


def watch_queue(queue_path):
    """Watch queue file for new text."""
    last_content = ""
    last_mtime = 0

    while True:
        try:
            if queue_path.exists():
                mtime = queue_path.stat().st_mtime
                if mtime > last_mtime:
                    content = queue_path.read_text().strip()
                    if content and content != last_content:
                        speak(content)
                        last_content = content
                        last_mtime = mtime
                        queue_path.write_text("")
        except Exception:
            pass
        time.sleep(0.2)


def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')


def render_ui(workspace, queue_path):
    """Render terminal UI."""
    while True:
        clear_screen()

        # Header
        print("\033[1;36m" + "=" * 50 + "\033[0m")
        print("\033[1;36m  🎙️  Kokoro TTS Server\033[0m")
        print("\033[1;36m" + "=" * 50 + "\033[0m")
        print()

        # Status
        ready_icon = "✅" if status["ready"] else "❌"
        speaking_icon = "🔊" if status["speaking"] else "🔇"

        print(f"  {ready_icon} Status:   {'Ready' if status['ready'] else 'Not Ready'}")
        print(f"  {speaking_icon} Speaking: {'Yes' if status['speaking'] else 'No'}")
        print(f"  🎭 Voice:    {status['voice']}")
        print(f"  📊 Total:    {status['total']} utterances")
        print()

        # Connection info
        print("\033[1;33m  Connection\033[0m")
        print(f"  📁 Watching: {queue_path}")
        queue_exists = "✅ exists" if queue_path.exists() else "⚠️  not found"
        print(f"  📄 Queue:    {queue_exists}")
        print()

        # History
        print("\033[1;33m  Recent History\033[0m")
        if history:
            for h in list(history)[-5:]:
                print(f"  \033[90m{h['time']}\033[0m {h['text']}")
                print(f"           \033[90mgen:{h['gen']} dur:{h['dur']}\033[0m")
        else:
            print("  \033[90m  No history yet...\033[0m")
        print()

        # Footer
        print("\033[90m" + "-" * 50 + "\033[0m")
        print("\033[90m  Press Ctrl+C to stop\033[0m")

        time.sleep(0.5)


def main():
    parser = argparse.ArgumentParser(description="Kokoro TTS Server")
    parser.add_argument("workspace", help="Path to claudio workspace")
    parser.add_argument("--voice", default=DEFAULT_VOICE, help="Default voice")
    args = parser.parse_args()

    status["voice"] = args.voice
    workspace = Path(args.workspace).resolve()
    queue_path = workspace / ".kokoro-queue"

    # Create queue file if missing
    queue_path.touch(exist_ok=True)

    print("Starting Kokoro TTS Server...")
    print(f"Workspace: {workspace}")

    if not init_kokoro():
        sys.exit(1)

    # Start watcher thread
    watcher = threading.Thread(target=watch_queue, args=(queue_path,), daemon=True)
    watcher.start()

    # Start UI
    try:
        render_ui(workspace, queue_path)
    except KeyboardInterrupt:
        print("\n\nShutting down...")


if __name__ == "__main__":
    main()
