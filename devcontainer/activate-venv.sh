#!/bin/bash
# Auto-activate uv virtual environment for this workspace

if [[ "$PWD" == /workspaces/claudio* ]] && [[ -f /workspaces/claudio/.venv/bin/activate ]]; then
    if [[ -z "$VIRTUAL_ENV" ]]; then
        source /workspaces/claudio/.venv/bin/activate
    fi
fi
