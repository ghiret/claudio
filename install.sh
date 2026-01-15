#!/bin/bash
set -e

# Claudio - Your AI Butler
# https://github.com/ghiret/claudio

VERSION="1.0.0"
REPO_URL="https://github.com/ghiret/claudio"
RAW_URL="https://raw.githubusercontent.com/ghiret/claudio/main"

# Colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Emoji support
EMOJI_CHECK="✓"
EMOJI_ARROW="→"
EMOJI_SPARKLE="✨"
EMOJI_FOLDER="📁"
EMOJI_GEAR="⚙️"
EMOJI_ROCKET="🚀"
EMOJI_HAT="🎩"
EMOJI_WAVE="👋"
EMOJI_WARN="⚠️"
EMOJI_ERROR="❌"
EMOJI_TRELLO="📋"
EMOJI_VOICE="🗣️"

print_banner() {
    echo ""
    echo -e "${MAGENTA}${BOLD}"
    echo "    ██████╗██╗      █████╗ ██╗   ██╗██████╗ ██╗ ██████╗ "
    echo "   ██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██║██╔═══██╗"
    echo "   ██║     ██║     ███████║██║   ██║██║  ██║██║██║   ██║"
    echo "   ██║     ██║     ██╔══██║██║   ██║██║  ██║██║██║   ██║"
    echo "   ╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝██║╚██████╔╝"
    echo "    ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝ ╚═════╝ "
    echo -e "${NC}"
    echo -e "   ${DIM}Your AI Butler ${NC}${EMOJI_HAT}${DIM}  •  Powered by Claude Code${NC}"
    echo ""
}

# Progress spinner
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " ${CYAN}[%c]${NC} " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b"
    done
    printf "     \b\b\b\b\b"
}

# Logging functions with style
info() {
    echo -e " ${CYAN}${EMOJI_ARROW}${NC}  $1"
}

step() {
    echo -e "\n${BLUE}${BOLD}$1${NC}"
}

success() {
    echo -e " ${GREEN}${EMOJI_CHECK}${NC}  $1"
}

warn() {
    echo -e " ${YELLOW}${EMOJI_WARN}${NC}  $1"
}

error() {
    echo -e " ${RED}${EMOJI_ERROR}${NC}  $1"
    exit 1
}

download_with_progress() {
    local url=$1
    local dest=$2
    local name=$3
    curl -sL "$url" -o "$dest"
    echo -e " ${GREEN}${EMOJI_CHECK}${NC}  ${DIM}$name${NC}"
}

# Parse arguments
INSTALL_DIR="$HOME/.claudio"
CONFIGURE_MCP=true
SKIP_PROMPTS=false

show_help() {
    print_banner
    echo -e "${BOLD}Usage:${NC} install.sh [OPTIONS]"
    echo ""
    echo -e "${BOLD}Options:${NC}"
    echo -e "  ${CYAN}--dir=PATH${NC}       Install to a specific directory"
    echo -e "                   ${DIM}Default: ~/.claudio${NC}"
    echo -e "  ${CYAN}--here${NC}           Install to current directory"
    echo -e "  ${CYAN}--no-mcp${NC}         Skip Trello MCP configuration"
    echo -e "  ${CYAN}--yes, -y${NC}        Skip confirmation prompts"
    echo -e "  ${CYAN}--help, -h${NC}       Show this help"
    echo ""
    echo -e "${BOLD}Examples:${NC}"
    echo -e "  ${DIM}# Install to default location (~/.claudio)${NC}"
    echo -e "  curl -sL $RAW_URL/install.sh | bash"
    echo ""
    echo -e "  ${DIM}# Install to current directory${NC}"
    echo -e "  curl -sL $RAW_URL/install.sh | bash -s -- --here"
    echo ""
    echo -e "  ${DIM}# Install to custom path${NC}"
    echo -e "  curl -sL $RAW_URL/install.sh | bash -s -- --dir=~/my-tasks"
    echo ""
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --dir=*)
            INSTALL_DIR="${1#*=}"
            shift
            ;;
        --here)
            INSTALL_DIR="$(pwd)"
            shift
            ;;
        --no-mcp)
            CONFIGURE_MCP=false
            shift
            ;;
        --yes|-y)
            SKIP_PROMPTS=true
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            error "Unknown option: $1\n  Run with --help for usage"
            ;;
    esac
done

# Expand ~ in path
INSTALL_DIR="${INSTALL_DIR/#\~/$HOME}"

print_banner

# Check for required tools
step "${EMOJI_GEAR} Checking requirements..."
command -v curl >/dev/null 2>&1 || error "curl is required but not installed"
success "curl available"
command -v git >/dev/null 2>&1 || error "git is required but not installed"
success "git available"

# Check if this is an update
IS_UPDATE=false
if [[ -f "$INSTALL_DIR/.claudio-version" ]]; then
    IS_UPDATE=true
    CURRENT_VERSION=$(cat "$INSTALL_DIR/.claudio-version")
    echo ""
    echo -e " ${MAGENTA}${EMOJI_SPARKLE}${NC}  ${BOLD}Update detected!${NC}"
    echo -e "    Current: ${DIM}v$CURRENT_VERSION${NC}"
    echo -e "    Latest:  ${GREEN}v$VERSION${NC}"
fi

# Confirm installation directory
if [[ "$SKIP_PROMPTS" != "true" && "$IS_UPDATE" != "true" ]]; then
    step "${EMOJI_FOLDER} Choose installation location"
    echo ""
    echo -e "    ${BOLD}Default:${NC} ${CYAN}$INSTALL_DIR${NC}"
    echo ""
    echo -e "    ${DIM}[1]${NC} Continue with default location"
    echo -e "    ${DIM}[2]${NC} Install here: ${DIM}$(pwd)${NC}"
    echo -e "    ${DIM}[3]${NC} Enter custom path"
    echo -e "    ${DIM}[4]${NC} Cancel installation"
    echo ""
    read -p "    Your choice [1]: " choice
    echo ""
    case $choice in
        2)
            INSTALL_DIR="$(pwd)"
            info "Installing to current directory"
            ;;
        3)
            read -p "    Enter path: " custom_path
            INSTALL_DIR="${custom_path/#\~/$HOME}"
            info "Installing to: $INSTALL_DIR"
            ;;
        4)
            echo -e " ${EMOJI_WAVE}  Installation cancelled. See you next time!"
            exit 0
            ;;
        *)
            info "Using default: $INSTALL_DIR"
            ;;
    esac
fi

# Create install directory
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

step "${EMOJI_ROCKET} Downloading Claudio..."
echo ""

# Create directory structure
mkdir -p .claude/skills .claude/scripts .devcontainer

# Download skills
echo -e " ${CYAN}Skills${NC}"
for skill in today add-task stuck review; do
    mkdir -p ".claude/skills/$skill"
    download_with_progress "$RAW_URL/skills/$skill/SKILL.md" ".claude/skills/$skill/SKILL.md" "$skill"
done

echo ""
echo -e " ${CYAN}Scripts${NC}"
for script in kokoro-server.py kokoro-server.sh setup-speech.sh speak-kokoro.sh speak.sh test-elevenlabs.sh; do
    download_with_progress "$RAW_URL/scripts/$script" ".claude/scripts/$script" "$script"
done
chmod +x .claude/scripts/*.sh

echo ""
echo -e " ${CYAN}Devcontainer${NC}"
download_with_progress "$RAW_URL/devcontainer/devcontainer.json" ".devcontainer/devcontainer.json" "devcontainer.json"
download_with_progress "$RAW_URL/devcontainer/Dockerfile" ".devcontainer/Dockerfile" "Dockerfile"
download_with_progress "$RAW_URL/devcontainer/activate-venv.sh" ".devcontainer/activate-venv.sh" "activate-venv.sh"

echo ""
echo -e " ${CYAN}Configuration${NC}"
download_with_progress "$RAW_URL/templates/CLAUDE.md" "CLAUDE.md" "CLAUDE.md"

# Download .env.example (don't overwrite .env)
if [[ ! -f ".env" ]]; then
    download_with_progress "$RAW_URL/templates/.env.example" ".env.example" ".env.example"
else
    success ".env preserved (not overwritten)"
fi

# Create history directory (user data, never touched on update)
mkdir -p history
if [[ ! -f "history/.gitkeep" ]]; then
    touch history/.gitkeep
fi

# Create .gitignore if not exists
if [[ ! -f ".gitignore" ]]; then
    cat > .gitignore << 'EOF'
# User data - never commit
.env
history/

# TTS queue files
.tts-queue
.kokoro-queue

# OS files
.DS_Store

# Claude settings (user-specific)
.claude/settings.json
.claude/settings.local.json
EOF
    success ".gitignore created"
else
    success ".gitignore preserved"
fi

# Write version file
echo "$VERSION" > .claudio-version

# Configure MCP
if [[ "$CONFIGURE_MCP" == "true" ]]; then
    CLAUDE_SETTINGS="$HOME/.claude/settings.json"

    # Check if MCP is already configured
    if [[ -f "$CLAUDE_SETTINGS" ]] && grep -q "trello" "$CLAUDE_SETTINGS" 2>/dev/null; then
        echo ""
        success "Trello MCP already configured ${DIM}($CLAUDE_SETTINGS)${NC}"
    else
        step "${EMOJI_TRELLO} Trello Setup"
        echo ""
        echo -e "    Claudio uses Trello to manage your tasks."
        echo -e "    You'll need an API key and token."
        echo ""
        echo -e "    ${BOLD}Step 1:${NC} Go to ${CYAN}https://trello.com/power-ups/admin${NC}"
        echo -e "    ${BOLD}Step 2:${NC} Create a new Power-Up (any name works)"
        echo -e "    ${BOLD}Step 3:${NC} Copy your API Key"
        echo ""

        read -p "    Trello API Key (or Enter to skip): " TRELLO_API_KEY

        if [[ -n "$TRELLO_API_KEY" ]]; then
            echo ""
            echo -e "    ${BOLD}Step 4:${NC} Get your token from this URL:"
            echo ""
            echo -e "    ${CYAN}https://trello.com/1/authorize?expiration=never&scope=read,write&response_type=token&key=$TRELLO_API_KEY${NC}"
            echo ""
            read -p "    Trello Token: " TRELLO_TOKEN

            if [[ -n "$TRELLO_TOKEN" ]]; then
                # Create Claude settings directory
                mkdir -p "$HOME/.claude"

                # Create or update settings.json
                if [[ -f "$CLAUDE_SETTINGS" ]]; then
                    # Backup existing
                    cp "$CLAUDE_SETTINGS" "$CLAUDE_SETTINGS.backup"

                    # Check if it's valid JSON with mcpServers
                    if python3 -c "import json; d=json.load(open('$CLAUDE_SETTINGS')); 'mcpServers' in d" 2>/dev/null; then
                        # Add trello to existing mcpServers
                        python3 << PYEOF
import json
with open('$CLAUDE_SETTINGS', 'r') as f:
    settings = json.load(f)
if 'mcpServers' not in settings:
    settings['mcpServers'] = {}
settings['mcpServers']['trello'] = {
    "command": "npx",
    "args": ["@delorenj/mcp-server-trello"],
    "env": {
        "TRELLO_API_KEY": "$TRELLO_API_KEY",
        "TRELLO_TOKEN": "$TRELLO_TOKEN"
    }
}
with open('$CLAUDE_SETTINGS', 'w') as f:
    json.dump(settings, f, indent=2)
PYEOF
                    else
                        # Create new settings with trello
                        cat > "$CLAUDE_SETTINGS" << JSONEOF
{
  "mcpServers": {
    "trello": {
      "command": "npx",
      "args": ["@delorenj/mcp-server-trello"],
      "env": {
        "TRELLO_API_KEY": "$TRELLO_API_KEY",
        "TRELLO_TOKEN": "$TRELLO_TOKEN"
      }
    }
  }
}
JSONEOF
                    fi
                else
                    # Create new settings file
                    cat > "$CLAUDE_SETTINGS" << JSONEOF
{
  "mcpServers": {
    "trello": {
      "command": "npx",
      "args": ["@delorenj/mcp-server-trello"],
      "env": {
        "TRELLO_API_KEY": "$TRELLO_API_KEY",
        "TRELLO_TOKEN": "$TRELLO_TOKEN"
      }
    }
  }
}
JSONEOF
                fi
                echo ""
                success "Trello MCP configured!"
            else
                warn "Skipped token. Configure later in ~/.claude/settings.json"
            fi
        else
            echo ""
            warn "Skipped Trello setup"
            info "You can configure it later by re-running this installer"
        fi
    fi
fi

# Success message
echo ""
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "   ${EMOJI_SPARKLE}  ${GREEN}${BOLD}Installation Complete!${NC}  ${EMOJI_SPARKLE}"
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "   ${EMOJI_FOLDER}  Installed to: ${CYAN}${BOLD}$INSTALL_DIR${NC}"
echo ""
echo -e "${WHITE}${BOLD}   Next Steps${NC}"
echo ""
echo -e "   ${DIM}1.${NC} Create a Trello board with these columns:"
echo -e "      ${CYAN}To Do${NC} │ ${CYAN}Blocked${NC} │ ${CYAN}Waiting On${NC} │ ${CYAN}In Progress${NC} │ ${CYAN}Done${NC}"
echo ""
echo -e "   ${DIM}2.${NC} Open in VS Code:"
echo -e "      ${DIM}\$${NC} ${WHITE}cd $INSTALL_DIR && code .${NC}"
echo ""
echo -e "   ${DIM}3.${NC} Start talking to Claudio:"
echo ""
echo -e "      ${DIM}>${NC} ${WHITE}today${NC}                              ${DIM}# Daily check-in${NC}"
echo -e "      ${DIM}>${NC} ${WHITE}add task: call the dentist${NC}         ${DIM}# Add a task${NC}"
echo -e "      ${DIM}>${NC} ${WHITE}I'm stuck on filing taxes${NC}          ${DIM}# Get unstuck${NC}"
echo -e "      ${DIM}>${NC} ${WHITE}what have I forgotten?${NC}             ${DIM}# Weekly review${NC}"
echo ""
echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "   ${EMOJI_VOICE}  ${BOLD}Optional: Voice Support (Mac)${NC}"
echo -e "      ${DIM}\$${NC} ${WHITE}$INSTALL_DIR/.claude/scripts/setup-speech.sh${NC}"
echo ""
echo -e "   ${EMOJI_ROCKET}  ${BOLD}Update Claudio${NC}"
echo -e "      ${DIM}\$${NC} ${WHITE}curl -sL $RAW_URL/install.sh | bash${NC}"
echo ""
echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
