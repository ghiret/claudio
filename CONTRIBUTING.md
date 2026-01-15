# Contributing to Claudio

Thanks for your interest in making Claudio better! Here's how to contribute.

## Development Setup

1. **Clone the repo** (don't use the installer for development):

   ```bash
   git clone https://github.com/ghiret/claudio.git
   cd claudio
   ```

2. **Set up pre-commit hooks** (recommended):

   ```bash
   pip install pre-commit
   pre-commit install
   ```

3. **Open in VS Code with the devcontainer** (optional but recommended)

4. **Set up Trello MCP** in `~/.claude/settings.json` if you haven't already

## CI Checks

Every PR runs these checks automatically:

| Check | What it does |
|-------|--------------|
| **ShellCheck** | Lints bash scripts for errors |
| **markdownlint** | Ensures consistent markdown |
| **Link checker** | Verifies documentation links work |
| **Syntax validation** | Checks all scripts have valid syntax |
| **Version consistency** | Ensures version numbers match |

Run locally with pre-commit:

```bash
pre-commit run --all-files
```

## Repository Structure

```text
claudio/
├── skills/                 # Skill definitions (installed to .claude/skills/)
│   ├── today/SKILL.md
│   ├── add-task/SKILL.md
│   ├── stuck/SKILL.md
│   └── review/SKILL.md
├── scripts/                # TTS and utility scripts (installed to .claude/scripts/)
├── devcontainer/           # VS Code devcontainer config (installed to .devcontainer/)
├── templates/              # Template files (CLAUDE.md, .env.example)
├── install.sh              # The installer script
├── README.md
├── CONTRIBUTING.md
└── LICENSE
```

## Adding a New Skill

1. Create a new directory under `skills/`:

   ```bash
   mkdir skills/my-skill
   ```

2. Create `skills/my-skill/SKILL.md` following this structure:

   ```markdown
   # Skill: my-skill

   ## When to Use
   - Trigger phrases: "my phrase", "another phrase"
   - Context: When the user wants X

   ## Workflow
   1. Step one
   2. Step two
   3. Step three

   ## Examples
   User: "my phrase"
   Claude: [What Claude should do]

   ## Notes
   - Important considerations
   ```

3. Update `install.sh` to include your skill in the download loop

4. Update `templates/CLAUDE.md` to reference your skill

5. Submit a PR!

## Skill Writing Guidelines

- **Be specific**: Clear trigger phrases help Claude know when to use the skill
- **Show examples**: Real input/output examples are invaluable
- **Keep it focused**: One skill = one workflow. If it's getting complex, split it
- **Test it**: Actually use the skill with Claude Code before submitting

## Modifying Existing Skills

- Keep backward compatibility in mind
- Test with common edge cases
- Update examples if behavior changes

## Scripts and Devcontainer

- Scripts should work on both Mac and Linux where possible
- The devcontainer is Ubuntu-based; test changes there
- TTS scripts are Mac-focused (Kokoro, PulseAudio) - that's intentional

## Pull Request Process

1. Fork the repo
2. Create a feature branch: `git checkout -b my-feature`
3. Make your changes
4. Test with Claude Code
5. Commit with a clear message
6. Push and open a PR

## Code of Conduct

Be kind. This is a hobby project. We're all here to make life admin less painful.

## Questions?

Open an issue! We're happy to help.
