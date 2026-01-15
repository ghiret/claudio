# Claudio - Your AI Butler

An AI-powered assistant for managing tasks and admin through Trello. Claudio helps reduce mental load by tracking tasks, surfacing forgotten items, and keeping you on top of everything.

## What Claudio Does
- 📅 **Daily check-ins** - "What should I focus on today?"
- ✅ **Task management** - Add well-formed, actionable tasks
- 🔓 **Unstick you** - Break down overwhelming tasks, prep phone scripts
- 🔍 **Surface forgotten items** - Weekly reviews to catch stale tasks
- 🗣️ **Voice support** - Talk to Claudio via dictation, hear responses via TTS

## Setup

1. **Set up Trello board** with columns: To Do | Blocked | Waiting On | In Progress | Done

2. **Get Trello API credentials:**
   - Go to https://trello.com/power-ups/admin
   - Create a Power-Up, get your API key
   - Generate a token: `https://trello.com/1/authorize?expiration=never&scope=read,write&response_type=token&key=YOUR_API_KEY`

3. **Configure Claude Code MCP** (in `~/.claude/settings.json`):
   ```json
   {
     "mcpServers": {
       "trello": {
         "command": "npx",
         "args": ["@delorenj/mcp-server-trello"],
         "env": {
           "TRELLO_API_KEY": "your_key",
           "TRELLO_TOKEN": "your_token"
         }
       }
     }
   }
   ```

4. **Open this folder in VS Code with Claude Code**

5. **(Optional) Set up Text-to-Speech** - Let Claude speak

   **One-time setup on your Mac:**
   ```bash
   .claude/scripts/setup-speech.sh
   ```
   This installs PulseAudio + Kokoro TTS with Apple Silicon acceleration.

   **Start speech services (choose one):**
   ```bash
   # Option A: PulseAudio only (for ElevenLabs/espeak)
   pulseaudio -vvv --load=module-native-protocol-tcp --exit-idle-time=-1

   # Option B: Kokoro server (local TTS, no API key)
   .claude/scripts/kokoro-server.sh .

   # Option C: Both (separate terminals)
   ```

   **TTS Options:**
   | Engine | Quality | Speed | Requires |
   |--------|---------|-------|----------|
   | ElevenLabs | Excellent | ~1.5s | API key, PulseAudio |
   | Kokoro | Great | ~0.3s | Kokoro server |
   | espeak-ng | Basic | Instant | PulseAudio |

   **Test from devcontainer:**
   ```bash
   .claude/scripts/test-elevenlabs.sh "Hello"   # ElevenLabs
   .claude/scripts/speak-kokoro.sh "Hello"      # Kokoro
   .claude/scripts/speak.sh "Hello"             # espeak
   ```

## Usage

Just talk to Claudio:

```
"today"                        → What should I focus on?
"add task: call a provider"     → Create a well-formed card
"I'm stuck on a task"           → Help breaking it down
"what have I forgotten"        → Surface stale items
"move X to done"               → Update Trello
```

## Project Structure

```
.
├── CLAUDE.md              # Instructions for Claude Code
├── .env                   # API keys (ELEVEN_API_KEY)
└── .claude/
    ├── scripts/
    │   ├── setup-speech.sh    # One-time Mac setup (PulseAudio + Kokoro)
    │   ├── kokoro-server.sh   # Run on Mac for local TTS
    │   ├── speak.sh           # espeak-ng (in container)
    │   ├── speak-kokoro.sh    # Kokoro (via Mac server)
    │   └── test-elevenlabs.sh # ElevenLabs (via PulseAudio)
    └── skills/
        ├── today/         # Morning check-in workflow
        ├── add-task/      # How to add good tasks
        ├── stuck/         # Help with blocked tasks
        └── review/        # Surface forgotten items
```

## Labels (set up in Trello)
- 🏠 Household - Home stuff
- 👶 Childcare - Family-related
- 📋 Admin - Bills, paperwork, finances
- 📞 Calls - Requires phone call
- ⏰ Time-sensitive - Has a deadline
- 🎉 Events - Birthdays, holidays
- 🚗 Transport - Car, travel
