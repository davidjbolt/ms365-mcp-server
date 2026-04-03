# Microsoft 365 MCP Server

Use Claude Code to read and send email, check your calendar, create meetings, and more — using your Delinea Microsoft 365 account.

Powered by [@softeria/ms-365-mcp-server](https://github.com/Softeria/ms-365-mcp-server).

## Quick Start

1. Clone the repo:
   ```bash
   git clone https://github.com/davidjbolt/ms365-mcp-server.git ~/ms365-mcp-server
   cd ~/ms365-mcp-server
   ```

2. Run the setup script:
   ```bash
   ./setup.sh
   ```
   This checks prerequisites and walks you through Microsoft login (device code flow — no Azure app registration required).

3. Launch Claude Code:
   ```bash
   cd ~/ms365-mcp-server && claude
   ```

4. Approve the MCP server when prompted — done.

## What You Can Do

| Capability | Examples |
|-----------|---------|
| **Read email** | "Show me unread emails from today", "Find emails from [person] about [topic]" |
| **Send email** | "Send an email to [person] with subject [X]", "Draft a reply to this thread" |
| **View calendar** | "What's on my calendar this week?", "What meetings do I have tomorrow?" |
| **Check availability** | "Am I free on Thursday afternoon?" |
| **Create meetings** | "Schedule a 1-hour meeting with [person] on Friday at 2pm" |
| **Manage invites** | "Accept the meeting invite from [person]" |

## Claude Desktop Setup

To use this in **Claude Desktop**, add the following to your config file:

- **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`

```json
"ms365": {
  "command": "/bin/bash",
  "args": ["/Users/YOUR_USERNAME/ms365-mcp-server/run.sh"]
}
```

Replace `YOUR_USERNAME` with your macOS username. Restart Claude Desktop after saving.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Auth errors / token expired | Re-run `./setup.sh` |
| MCP server not connecting | Run `claude` from inside this repo directory |
| Tenant blocks the default app | See [setup-instructions.md](setup-instructions.md) for custom Azure app option |
