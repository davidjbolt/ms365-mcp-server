#!/bin/bash

# Microsoft 365 MCP Server — Setup Script
# Run this after cloning the repo to get everything configured.

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

check_pass() { echo -e "  ${GREEN}✔${NC} $1"; }
check_fail() { echo -e "  ${RED}✘${NC} $1"; }
check_warn() { echo -e "  ${YELLOW}!${NC} $1"; }

echo ""
echo "==================================="
echo " Microsoft 365 MCP Server Setup"
echo "==================================="
echo ""

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MISSING=0

# --- Node.js ---
echo "Checking prerequisites..."
echo ""

if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    NODE_MAJOR=$(echo "$NODE_VERSION" | sed 's/v//' | cut -d. -f1)
    if [ "$NODE_MAJOR" -ge 18 ]; then
        check_pass "Node.js $NODE_VERSION"
    else
        check_fail "Node.js $NODE_VERSION (need v18+)"
        echo ""
        echo "    Upgrade: brew install node"
        MISSING=1
    fi
else
    check_fail "Node.js not found"
    echo ""
    echo "    Install: brew install node"
    MISSING=1
fi

# --- Claude Code ---
if command -v claude &> /dev/null; then
    check_pass "Claude Code"
else
    check_warn "Claude Code not found (optional — needed to use this from the terminal)"
    echo ""
    echo "    Install: npm install -g @anthropic-ai/claude-code"
fi

echo ""

if [ "$MISSING" -eq 1 ]; then
    echo -e "${RED}Some prerequisites are missing. Install them and re-run this script.${NC}"
    echo ""
    exit 1
fi

# --- run.sh permissions ---
chmod +x "$DIR/run.sh"
check_pass "run.sh is executable"
echo ""

# --- .env setup ---
echo "Checking Azure credentials..."
echo ""

if [ ! -f "$DIR/.env" ]; then
    cp "$DIR/.env.example" "$DIR/.env"
    check_warn ".env created from template — you need to add your Azure credentials"
    echo ""
    echo "    Open .env and fill in:"
    echo "      MS365_MCP_CLIENT_ID   — from your Azure app registration"
    echo "      MS365_MCP_TENANT_ID   — your Azure tenant ID"
    echo ""
    echo "    See setup-instructions.md for step-by-step Azure setup."
    echo ""
    exit 0
fi

source "$DIR/.env"

if [ -z "$MS365_MCP_CLIENT_ID" ] || [ "$MS365_MCP_CLIENT_ID" = "your-azure-app-client-id-here" ]; then
    check_fail "MS365_MCP_CLIENT_ID not set in .env"
    echo ""
    echo "    See setup-instructions.md for Azure app registration steps."
    MISSING=1
else
    check_pass "MS365_MCP_CLIENT_ID is set"
fi

if [ -z "$MS365_MCP_TENANT_ID" ] || [ "$MS365_MCP_TENANT_ID" = "your-azure-tenant-id-here" ]; then
    check_fail "MS365_MCP_TENANT_ID not set in .env"
    MISSING=1
else
    check_pass "MS365_MCP_TENANT_ID is set"
fi

echo ""

if [ "$MISSING" -eq 1 ]; then
    echo -e "${RED}Credentials missing. Update .env and re-run this script.${NC}"
    echo ""
    exit 1
fi

# --- Token cache directory ---
mkdir -p "$HOME/.config/ms365-mcp"
check_pass "Token cache directory ready (~/.config/ms365-mcp/)"
echo ""

# --- Microsoft 365 Auth ---
echo "Checking Microsoft 365 authentication..."
echo ""

CACHE_PATH="$HOME/.config/ms365-mcp/.token-cache.json"

if [ -f "$CACHE_PATH" ] && [ -s "$CACHE_PATH" ]; then
    check_pass "Token cache found — you appear to be authenticated"
    echo ""
else
    check_warn "No cached token found — logging in now"
    echo ""
    echo "    A device code will appear. Visit https://microsoft.com/devicelogin"
    echo "    and enter the code to log in with your Delinea Microsoft account."
    echo ""
    read -p "    Press Enter to start the login process..."
    echo ""
    MS365_MCP_CLIENT_ID="$MS365_MCP_CLIENT_ID" \
    MS365_MCP_TENANT_ID="$MS365_MCP_TENANT_ID" \
    MS365_MCP_TOKEN_CACHE_PATH="$CACHE_PATH" \
        npx -y @softeria/ms-365-mcp-server --login

    if [ -f "$CACHE_PATH" ] && [ -s "$CACHE_PATH" ]; then
        echo ""
        check_pass "Authenticated successfully"
    else
        echo ""
        check_fail "Authentication failed — token cache not found after login"
        echo ""
        echo "    Try running manually:"
        echo "      MS365_MCP_CLIENT_ID=\$MS365_MCP_CLIENT_ID MS365_MCP_TENANT_ID=\$MS365_MCP_TENANT_ID npx @softeria/ms-365-mcp-server --login"
        exit 1
    fi
fi

# --- Done ---
echo "==================================="
echo -e " ${GREEN}Setup complete!${NC}"
echo "==================================="
echo ""
echo " To get started:"
echo ""
echo "   Claude Code:    Run 'claude' from this directory"
echo "   Claude Desktop: See README.md for config instructions"
echo ""
