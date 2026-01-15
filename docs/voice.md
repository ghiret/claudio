<p align="center">
  <img src="../claudio_logo.png" alt="Claudio" width="200">
</p>

# Voice Support

Claudio can speak! This page covers the three TTS engines available.

## Overview

```mermaid
flowchart LR
    subgraph Engines["TTS Engines"]
        kokoro["🏠 Kokoro<br/>Local • Fast • Free"]
        eleven["☁️ ElevenLabs<br/>Cloud • Premium • Paid"]
        espeak["🔧 espeak-ng<br/>Fallback • Basic • Free"]
    end

    subgraph Output["🔊"]
        speaker["Audio"]
    end

    kokoro --> speaker
    eleven --> speaker
    espeak --> speaker
```

## Comparison

| Engine | Quality | Latency | Cost | Platform | Best For |
|--------|---------|---------|------|----------|----------|
| **Kokoro** | ⭐⭐⭐⭐ Great | ~300ms | Free | Mac (Apple Silicon) | Daily use |
| **ElevenLabs** | ⭐⭐⭐⭐⭐ Excellent | ~1.5s | Paid | Any | Premium experience |
| **espeak-ng** | ⭐⭐ Basic | Instant | Free | Any | Fallback |

## Kokoro (Recommended)

Local TTS using [Kokoro ONNX](https://github.com/thewh1teagle/kokoro-onnx) - runs entirely on your Mac with Apple Silicon acceleration.

### How It Works

```mermaid
sequenceDiagram
    participant Claude as Claude Code<br/>(Container)
    participant Queue as .kokoro-queue<br/>(Shared File)
    participant Server as kokoro-server.py<br/>(Mac)
    participant Model as Kokoro ONNX
    participant Speaker as 🔊 Speakers

    Claude->>Queue: Write "Hello, world"
    Note over Queue: File change detected
    Queue-->>Server: inotify/fswatch
    Server->>Model: Generate audio
    Model-->>Server: WAV data
    Server->>Speaker: Play audio
```

### Setup

```bash
# One-time setup (installs PulseAudio, Python deps, downloads model)
~/.claudio/.claude/scripts/setup-speech.sh

# Start the server (run in a separate terminal)
~/.claudio/.claude/scripts/kokoro-server.sh ~/.claudio
```

### Server UI

The Kokoro server shows a live terminal UI:

```text
╭─────────────────────────────────────────────────────────────╮
│  🎙️  Kokoro TTS Server                                      │
│                                                             │
│  Status: ● Listening                                        │
│  Voice:  af_heart                                           │
│  Queue:  /Users/you/.claudio/.kokoro-queue                  │
│                                                             │
│  Recent:                                                    │
│  ├─ "Here's your focus for today..."                       │
│  ├─ "Task added: Call the dentist"                         │
│  └─ "I've moved that to Done"                              │
╰─────────────────────────────────────────────────────────────╯
```

### Available Voices

| Voice ID | Description |
|----------|-------------|
| `af_heart` | Default, warm and friendly |
| `af_bella` | Clear and professional |
| `af_sarah` | Soft and calm |
| `am_adam` | Male, neutral |
| `am_michael` | Male, warm |

Change voice:

```bash
~/.claudio/.claude/scripts/kokoro-server.sh ~/.claudio af_bella
```

## ElevenLabs

Cloud-based premium TTS with natural intonation.

### How It Works

```mermaid
sequenceDiagram
    participant Claude as Claude Code<br/>(Container)
    participant Script as test-elevenlabs.sh
    participant Pulse as PulseAudio<br/>(Mac Host)
    participant API as ElevenLabs API
    participant Speaker as 🔊 Speakers

    Claude->>Script: "Hello, world"
    Script->>API: POST /text-to-speech
    API-->>Script: MP3 audio
    Script->>Pulse: Stream audio
    Pulse->>Speaker: Play
```

### Setup

1. Get an API key from [elevenlabs.io](https://elevenlabs.io)

2. Add to `~/.claudio/.env`:

   ```text
   ELEVEN_API_KEY=your_key_here
   ```

3. Start PulseAudio on your Mac:

   ```bash
   pulseaudio --load=module-native-protocol-tcp --exit-idle-time=-1
   ```

4. Test:

   ```bash
   ~/.claudio/.claude/scripts/test-elevenlabs.sh "Hello from ElevenLabs"
   ```

### Voice Selection

Default voice is "Daniel" (Steady Broadcaster). To change, edit `test-elevenlabs.sh`.

## espeak-ng (Fallback)

Basic TTS built into the devcontainer. Not as natural but always available.

### How It Works

```mermaid
sequenceDiagram
    participant Claude as Claude Code<br/>(Container)
    participant Script as speak.sh
    participant espeak as espeak-ng
    participant Pulse as PulseAudio<br/>(Mac Host)
    participant Speaker as 🔊 Speakers

    Claude->>Script: "Hello, world"
    Script->>espeak: Generate
    espeak->>Pulse: Stream
    Pulse->>Speaker: Play
```

### Setup

Just needs PulseAudio running on your Mac:

```bash
pulseaudio --load=module-native-protocol-tcp --exit-idle-time=-1
```

Test:

```bash
~/.claudio/.claude/scripts/speak.sh "Hello from espeak"
```

## Troubleshooting

### No audio on Mac

1. Check PulseAudio is running:

   ```bash
   pulseaudio --check && echo "Running" || echo "Not running"
   ```

2. Restart PulseAudio:

   ```bash
   pulseaudio --kill
   pulseaudio --load=module-native-protocol-tcp --exit-idle-time=-1
   ```

### Kokoro server not picking up text

1. Check the queue file exists and is writable
2. Ensure the server is watching the correct directory
3. Check server logs for errors

### ElevenLabs returns error

1. Verify API key is set in `.env`
2. Check your API quota at elevenlabs.io
3. Ensure you're not rate-limited
