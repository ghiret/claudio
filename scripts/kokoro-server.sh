#!/bin/bash
# Run this on your Mac HOST (not in the devcontainer)
# Launches Kokoro TTS Server with proper venv
#
# Usage: ./kokoro-server.sh /path/to/claudio [--voice bm_george]

KOKORO_DIR="$HOME/.kokoro"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# Parse args
WORKSPACE="${1:-.}"
VOICE="${2:-bm_george}"

echo ""
echo -e "${CYAN}${BOLD}=================================================${NC}"
echo -e "${CYAN}${BOLD}  🎙️  Kokoro TTS Server                          ${NC}"
echo -e "${CYAN}${BOLD}=================================================${NC}"
echo ""

# Check setup
echo -e "${BLUE}Checking setup...${NC}"

if [ ! -d "$KOKORO_DIR" ]; then
    echo -e "${RED}❌ Kokoro not installed${NC}"
    echo -e "   Run: ${YELLOW}./setup-kokoro.sh${NC}"
    exit 1
fi

if [ ! -f "$KOKORO_DIR/kokoro-v1.0.onnx" ]; then
    echo -e "${RED}❌ Model not found${NC}"
    echo -e "   Run: ${YELLOW}./setup-kokoro.sh${NC}"
    exit 1
fi

if [ ! -d "$KOKORO_DIR/venv" ]; then
    echo -e "${RED}❌ Virtual environment not found${NC}"
    echo -e "   Run: ${YELLOW}./setup-kokoro.sh${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Kokoro directory: $KOKORO_DIR${NC}"
echo -e "${GREEN}✅ Model found${NC}"
echo -e "${GREEN}✅ Virtual environment found${NC}"

# Resolve workspace path
WORKSPACE=$(cd "$WORKSPACE" 2>/dev/null && pwd)
if [ -z "$WORKSPACE" ]; then
    echo -e "${RED}❌ Invalid workspace path${NC}"
    exit 1
fi

QUEUE_FILE="$WORKSPACE/.kokoro-queue"
touch "$QUEUE_FILE"

echo -e "${GREEN}✅ Workspace: $WORKSPACE${NC}"
echo -e "${GREEN}✅ Queue file: $QUEUE_FILE${NC}"
echo ""

# Activate venv
echo -e "${BLUE}Activating virtual environment...${NC}"
source "$KOKORO_DIR/venv/bin/activate"
echo -e "${GREEN}✅ Venv activated${NC}"
echo ""

# Launch server
echo -e "${BLUE}Launching server...${NC}"
echo ""

# Run the Python server
exec python3 "$SCRIPT_DIR/kokoro-server.py" "$WORKSPACE" --voice "$VOICE"
