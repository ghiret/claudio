#!/bin/bash
# Send text to Kokoro running on Mac host
# Requires kokoro-watcher.sh running on Mac
#
# Usage: ./speak-kokoro.sh "Text to speak"

TEXT="${1:-Hello from the devcontainer via Kokoro}"
QUEUE_FILE="/workspaces/claudio/.kokoro-queue"

echo "$TEXT" > "$QUEUE_FILE"
echo "Sent to Kokoro: $TEXT"
