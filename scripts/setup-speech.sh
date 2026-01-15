#!/bin/bash
# Run this on your Mac HOST (not in the devcontainer)
# Sets up all TTS options: PulseAudio + Kokoro
#
# Usage: ./setup-speech.sh

set -e

KOKORO_DIR="$HOME/.kokoro"
MODEL_URL="https://github.com/thewh1teagle/kokoro-onnx/releases/download/model-files-v1.0"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

print_header() {
    echo ""
    echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}${BOLD}  🔊 Speech Setup for Claudio                        ${NC}"
    echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "  This script sets up:"
    echo -e "  ${GREEN}•${NC} PulseAudio  - Audio bridge to devcontainer (ElevenLabs, espeak)"
    echo -e "  ${GREEN}•${NC} Kokoro      - Local TTS with Apple Silicon acceleration"
    echo ""
}

print_section() {
    echo ""
    echo -e "${MAGENTA}${BOLD}────────────────────────────────────────────────────${NC}"
    echo -e "${MAGENTA}${BOLD}  $1${NC}"
    echo -e "${MAGENTA}${BOLD}────────────────────────────────────────────────────${NC}"
    echo ""
}

check_command() {
    if command -v "$1" &> /dev/null; then
        echo -e "${GREEN}✅ $1 found${NC}"
        return 0
    else
        echo -e "${RED}❌ $1 not found${NC}"
        return 1
    fi
}

# ═══════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════

print_header

# ───────────────────────────────────────────────────────────────────
# PULSEAUDIO SETUP
# ───────────────────────────────────────────────────────────────────

print_section "1. PulseAudio Setup"

echo -e "${BLUE}Checking Homebrew...${NC}"
if ! check_command brew; then
    echo -e "   Install from: ${YELLOW}https://brew.sh${NC}"
    echo -e "   Then re-run this script"
    exit 1
fi

echo ""
echo -e "${BLUE}Checking PulseAudio...${NC}"
if ! check_command pulseaudio; then
    echo -e "   ${YELLOW}Installing PulseAudio via Homebrew...${NC}"
    brew install pulseaudio
    echo -e "${GREEN}✅ PulseAudio installed${NC}"
else
    echo -e "${GREEN}✅ PulseAudio already installed${NC}"
fi

# ───────────────────────────────────────────────────────────────────
# KOKORO SETUP
# ───────────────────────────────────────────────────────────────────

print_section "2. Kokoro TTS Setup"

echo -e "${BLUE}Checking Python...${NC}"
if ! check_command python3; then
    echo -e "   Install via: ${YELLOW}brew install python3${NC}"
    exit 1
fi
echo -e "   ${DIM}$(python3 --version)${NC}"

echo ""
echo -e "${BLUE}Setting up Kokoro directory...${NC}"
mkdir -p "$KOKORO_DIR"
echo -e "${GREEN}✅ Directory: $KOKORO_DIR${NC}"

cd "$KOKORO_DIR"

echo ""
echo -e "${BLUE}Setting up virtual environment...${NC}"
if [ ! -d "venv" ]; then
    echo -e "   Creating venv..."
    python3 -m venv venv
fi
echo -e "${GREEN}✅ Virtual environment ready${NC}"

echo ""
echo -e "${BLUE}Installing Python packages...${NC}"
# shellcheck source=/dev/null
source venv/bin/activate
pip install --upgrade pip --quiet
pip install kokoro-onnx soundfile sounddevice --quiet
echo -e "${GREEN}✅ Packages installed${NC}"
echo -e "   ${DIM}kokoro-onnx, soundfile, sounddevice${NC}"

echo ""
echo -e "${BLUE}Downloading model files...${NC}"

if [ ! -f "kokoro-v1.0.onnx" ]; then
    echo -e "   ${YELLOW}Downloading kokoro-v1.0.onnx (~350MB)...${NC}"
    curl -L --progress-bar -o kokoro-v1.0.onnx "$MODEL_URL/kokoro-v1.0.onnx"
fi
echo -e "${GREEN}✅ Model: kokoro-v1.0.onnx ($(du -h kokoro-v1.0.onnx | cut -f1))${NC}"

if [ ! -f "voices-v1.0.bin" ]; then
    echo -e "   ${YELLOW}Downloading voices-v1.0.bin...${NC}"
    curl -L --progress-bar -o voices-v1.0.bin "$MODEL_URL/voices-v1.0.bin"
fi
echo -e "${GREEN}✅ Voices: voices-v1.0.bin${NC}"

# ───────────────────────────────────────────────────────────────────
# SUMMARY
# ───────────────────────────────────────────────────────────────────

print_section "Setup Complete!"

echo -e "  ${BOLD}TTS Options Available:${NC}"
echo ""
echo -e "  ${CYAN}1. ElevenLabs${NC} ${DIM}(API, best quality)${NC}"
echo -e "     Runs in devcontainer via PulseAudio"
echo -e "     Requires: ELEVEN_API_KEY in .env"
echo ""
echo -e "  ${CYAN}2. Kokoro${NC} ${DIM}(local, Apple Silicon accelerated)${NC}"
echo -e "     Runs on Mac, ~350MB model"
echo -e "     Free, no API key needed"
echo ""
echo -e "  ${CYAN}3. espeak-ng${NC} ${DIM}(fallback, basic)${NC}"
echo -e "     Runs in devcontainer via PulseAudio"
echo -e "     Always available"
echo ""

echo -e "${MAGENTA}${BOLD}────────────────────────────────────────────────────${NC}"
echo -e "${BOLD}  To Start Speech Services:${NC}"
echo -e "${MAGENTA}${BOLD}────────────────────────────────────────────────────${NC}"
echo ""
echo -e "  ${BOLD}Option A: PulseAudio only${NC} (for ElevenLabs/espeak)"
echo -e "  ${YELLOW}pulseaudio -vvv --load=module-native-protocol-tcp --exit-idle-time=-1${NC}"
echo ""
echo -e "  ${BOLD}Option B: Kokoro server${NC} (local TTS)"
echo -e "  ${YELLOW}.claude/scripts/kokoro-server.sh /path/to/claudio${NC}"
echo ""
echo -e "  ${BOLD}Option C: Both${NC} (run in separate terminals)"
echo -e "  ${DIM}Terminal 1:${NC} pulseaudio -vvv --load=module-native-protocol-tcp --exit-idle-time=-1"
echo -e "  ${DIM}Terminal 2:${NC} .claude/scripts/kokoro-server.sh ."
echo ""
