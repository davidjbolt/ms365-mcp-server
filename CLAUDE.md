# Microsoft 365 MCP Server

This repo connects Claude Code to Microsoft 365 via the `@softeria/ms-365-mcp-server` package.

## What's available

When the MCP server is active, you can interact with:

- **Email** — read, search, send, draft, organise
- **Calendar** — view events, check availability, create/update/delete events, accept invites

Both use your Delinea Microsoft 365 account (the account you logged in with during setup).

## Example prompts

**Email:**
- "Show me unread emails from today"
- "Find emails from [person] about [topic]"
- "Draft a reply to [email] saying..."
- "Send an email to [person] with subject [X] and body [Y]"

**Calendar:**
- "What's on my calendar this week?"
- "Am I free on Thursday afternoon?"
- "Schedule a 1-hour meeting with [person] on Friday at 2pm"
- "Accept the meeting invite from [person]"
- "What meetings do I have tomorrow?"

## Auth

Credentials are stored in `~/.config/ms365-mcp/.token-cache.json`. If your token expires, re-run `./setup.sh`.
