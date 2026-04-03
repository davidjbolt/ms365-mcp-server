#!/bin/bash

# Starts the MS365 MCP server using the package's built-in default app.
# Used by .mcp.json — not intended to be run directly.

export MS365_MCP_TOKEN_CACHE_PATH="$HOME/.config/ms365-mcp/.token-cache.json"
export MS365_MCP_SELECTED_ACCOUNT_PATH="$HOME/.config/ms365-mcp/.selected-account.json"

exec npx -y @softeria/ms-365-mcp-server \
    --org-mode \
    --preset mail \
    --preset calendar \
    --toon
