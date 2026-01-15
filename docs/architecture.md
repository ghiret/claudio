<p align="center">
  <img src="../claudio_logo.png" alt="Claudio" width="200">
</p>

# Architecture

How Claudio works under the hood.

## System Overview

```mermaid
flowchart TB
    subgraph You["👤 You"]
        voice["🎤 Voice Input"]
        text["⌨️ Text Input"]
    end

    subgraph Claude["🤖 Claude Code"]
        skills["Skills<br/>.claude/skills/"]
        mcp["Trello MCP"]
    end

    subgraph Backend["☁️ Backend"]
        trello["📋 Trello Board"]
    end

    subgraph Output["📢 Output"]
        terminal["Terminal"]
        tts["🔊 Voice (TTS)"]
    end

    voice --> Claude
    text --> Claude
    skills --> mcp
    mcp <--> trello
    Claude --> terminal
    Claude --> tts
```

## Skill Flow

When you say something like "today", here's what happens:

```mermaid
sequenceDiagram
    participant You
    participant Claude
    participant Skill as today/SKILL.md
    participant MCP as Trello MCP
    participant Trello

    You->>Claude: "today"
    Claude->>Skill: Load skill instructions
    Skill-->>Claude: Workflow steps
    Claude->>MCP: Get all cards
    MCP->>Trello: API request
    Trello-->>MCP: Board data
    MCP-->>Claude: Cards, lists, labels
    Claude->>Claude: Analyze & prioritize
    Claude->>You: "Here's your focus for today..."
    Claude->>You: 🔊 (optional voice)
```

## Installation Flow

```mermaid
flowchart LR
    subgraph Install["curl ... | bash"]
        A["📥 Download"] --> B["📁 Create dirs"]
        B --> C["⬇️ Fetch skills"]
        C --> D["⬇️ Fetch scripts"]
        D --> E["🔧 Configure MCP"]
    end

    subgraph Result["~/.claudio/"]
        F[".claude/skills/"]
        G[".claude/scripts/"]
        H[".devcontainer/"]
        I["CLAUDE.md"]
    end

    Install --> Result
```

## Voice Architecture

```mermaid
flowchart TB
    subgraph Container["🐳 Devcontainer"]
        claude["Claude Code"]
        script["speak-kokoro.sh"]
        queue["📄 .kokoro-queue"]
    end

    subgraph Mac["💻 Mac Host"]
        server["kokoro-server.py"]
        model["🧠 Kokoro ONNX"]
        audio["🔊 Audio Output"]
    end

    claude -->|"text"| script
    script -->|"write"| queue
    queue -.->|"watch"| server
    server --> model
    model --> audio
```

## Data Flow

```mermaid
flowchart LR
    subgraph Ephemeral["Ephemeral (never stored)"]
        conv["Conversation"]
    end

    subgraph Trello["Trello (source of truth)"]
        cards["Cards"]
        lists["Lists"]
        labels["Labels"]
    end

    subgraph Local["Local (optional)"]
        history["history/*.md"]
        env[".env"]
    end

    conv --> Trello
    Trello --> history
    env -.->|"API keys"| conv
```

## Component Responsibilities

| Component | Purpose |
|-----------|---------|
| **Skills** | Define workflows - what Claude does for each command |
| **Trello MCP** | Bridge between Claude and Trello API |
| **Scripts** | TTS, setup utilities |
| **Devcontainer** | Consistent development environment |
| **CLAUDE.md** | Global context for Claude about your setup |
| **history/** | Optional daily logs for pattern tracking |
