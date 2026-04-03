#!/bin/bash

# Loads credentials from .env and starts the MS365 MCP server.
# Used by .mcp.json — not intended to be run directly.

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -f "$DIR/.env" ]; then
    echo "Error: .env file not found. Run setup.sh first." >&2
    exit 1
fi

source "$DIR/.env"

export MS365_MCP_TOKEN_CACHE_PATH="$HOME/.config/ms365-mcp/.token-cache.json"
export MS365_MCP_SELECTED_ACCOUNT_PATH="$HOME/.config/ms365-mcp/.selected-account.json"

exec npx -y @softeria/ms-365-mcp-server \
    --org-mode \
    --preset mail \
    --preset calendar \
    --toon
