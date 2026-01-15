#!/bin/bash
# Text-to-speech from devcontainer
# Uses espeak-ng with PulseAudio forwarding to Mac host
#
# Usage: ./speak.sh "Text to speak"

TEXT="${1:-Hello from Claude}"

# Use espeak-ng (requires PulseAudio on Mac host)
espeak-ng "$TEXT" 2>/dev/null || echo "TTS failed - is PulseAudio running on Mac? Run: pulseaudio --load=module-native-protocol-tcp --exit-idle-time=-1 --daemon"
