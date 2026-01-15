<p align="center">
  <img src="claudio_logo.png" alt="Claudio - AI Butler" width="400">
</p>

<p align="center">
  <strong>Your AI Butler</strong> — A Claude Code skill set for managing life admin through Trello.
</p>

<p align="center">
  <a href="#quick-start">Quick Start</a> •
  <a href="docs/skills.md">Skills</a> •
  <a href="docs/voice.md">Voice</a> •
  <a href="docs/architecture.md">Architecture</a>
</p>

---

Claudio helps reduce mental load by tracking tasks, surfacing forgotten items, and keeping you on top of everything from paying bills to booking appointments.

## Quick Start

```bash
curl -sL https://raw.githubusercontent.com/ghiret/claudio/main/install.sh | bash
```

The installer will:
- Download skills, scripts, and devcontainer to `~/.claudio`
- Walk you through Trello API setup
- Configure the MCP in Claude Code

Then open in VS Code and start talking:

```bash
cd ~/.claudio && code .
```

## What Claudio Does

| Say this... | Claudio will... | Docs |
|------------|-----------------|------|
| `today` | Check your board, summarize priorities, surface stale tasks | [→](docs/skills.md#today) |
| `add task: call the dentist` | Create a well-formed Trello card with context | [→](docs/skills.md#add-task) |
| `I'm stuck on filing taxes` | Break it down, prep a phone script, or identify blockers | [→](docs/skills.md#stuck) |
| `what have I forgotten?` | Review stale tasks, archive done items, suggest follow-ups | [→](docs/skills.md#review) |

## Documentation

| Doc | Description |
|-----|-------------|
| [**Skills**](docs/skills.md) | All available commands with examples |
| [**Voice**](docs/voice.md) | TTS setup guide (Kokoro, ElevenLabs, espeak) |
| [**Architecture**](docs/architecture.md) | System diagrams and data flow |

## Installation Options

```bash
# Default: install to ~/.claudio
curl -sL https://raw.githubusercontent.com/ghiret/claudio/main/install.sh | bash

# Install to current directory
curl -sL https://raw.githubusercontent.com/ghiret/claudio/main/install.sh | bash -s -- --here

# Install to custom path
curl -sL https://raw.githubusercontent.com/ghiret/claudio/main/install.sh | bash -s -- --dir=~/my-tasks

# Update existing installation
curl -sL https://raw.githubusercontent.com/ghiret/claudio/main/install.sh | bash
```

## Requirements

- [Claude Code](https://claude.ai/code) (the CLI)
- A Trello account
- Node.js (for the Trello MCP)

## Trello Board Setup

Create a board with these columns:

```
To Do │ Blocked │ Waiting On │ In Progress │ Done
```

And these labels (optional but helpful):

- 🏠 Household - Home stuff
- 👶 Childcare - Kid-related
- 📋 Admin - Bills, paperwork, finances
- 📞 Calls - Requires phone call
- ⏰ Time-sensitive - Has a deadline
- 🎉 Events - Birthdays, holidays
- 🚗 Transport - Car, travel

## Voice Support (Optional)

Claudio can speak! Three TTS engines available:

| Engine | Quality | Speed | Setup |
|--------|---------|-------|-------|
| **Kokoro** | ⭐⭐⭐⭐ | ~0.3s | Local, Mac only, free |
| **ElevenLabs** | ⭐⭐⭐⭐⭐ | ~1.5s | API key required |
| **espeak-ng** | ⭐⭐ | Instant | Built into devcontainer |

Quick setup for Kokoro (recommended):
```bash
~/.claudio/.claude/scripts/setup-speech.sh
~/.claudio/.claude/scripts/kokoro-server.sh ~/.claudio
```

See [docs/voice.md](docs/voice.md) for full setup instructions and troubleshooting.

## Project Structure (After Install)

```
~/.claudio/
├── .claude/
│   ├── skills/           # Workflow definitions
│   │   ├── today/        # Daily check-in
│   │   ├── add-task/     # Task creation
│   │   ├── stuck/        # Breaking blockers
│   │   └── review/       # Weekly cleanup
│   └── scripts/          # TTS and utilities
├── .devcontainer/        # VS Code devcontainer
├── history/              # Your daily logs (not synced)
├── CLAUDE.md             # Instructions for Claude
└── .env                  # Your API keys (not synced)
```

## Updating

Re-run the installer to get the latest skills and scripts:

```bash
curl -sL https://raw.githubusercontent.com/ghiret/claudio/main/install.sh | bash
```

Your `history/` and `.env` are never touched during updates.

## Contributing

Want to add a skill or improve existing ones? See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT - See [LICENSE](LICENSE)

---

*Claudio: Because everyone deserves a butler.* 🎩

<p align="center">
  <sub>Built entirely with <a href="https://claude.ai/code">Claude Code</a> 🤖</sub>
</p>
