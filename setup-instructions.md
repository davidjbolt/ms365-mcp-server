# Setup Instructions — Microsoft 365 MCP Server

Step-by-step guide for first-time setup.

---

## Prerequisites

- **Node.js 18+** — install with `brew install node`
- **Claude Code** — install with `npm install -g @anthropic-ai/claude-code`
- **An Azure account** with access to the Delinea tenant (your normal Microsoft 365 login)

---

## Step 1 — Register an Azure App

You need to register an app in Azure Entra ID to get credentials the MCP server can use.

1. Go to [portal.azure.com](https://portal.azure.com) and sign in with your Delinea account
2. Search for **"App registrations"** and open it
3. Click **New registration**
4. Fill in:
   - **Name:** `MS365 MCP Server` (or anything you like)
   - **Supported account types:** Accounts in this organizational directory only
   - **Redirect URI:** leave blank for now
5. Click **Register**
6. On the app overview page, copy:
   - **Application (client) ID** → you'll need this shortly
   - **Directory (tenant) ID** → you'll need this shortly

---

## Step 2 — Add API Permissions

1. In your app registration, go to **API permissions** → **Add a permission**
2. Choose **Microsoft Graph** → **Delegated permissions**
3. Search for and add each of these:
   - `Mail.Read`
   - `Mail.Send`
   - `Calendars.Read`
   - `Calendars.ReadWrite`
4. Click **Add permissions**

> These are delegated permissions — they act on your behalf when you're signed in. No admin consent is required.

---

## Step 3 — Configure Authentication

1. In your app registration, go to **Authentication**
2. Click **Add a platform** → **Mobile and desktop applications**
3. Check the box for `https://login.microsoftonline.com/common/oauth2/nativeclient`
4. Click **Configure**

This enables the device code login flow used by the setup script.

---

## Step 4 — Set Up Your Credentials

1. Clone the repo (if you haven't already):
   ```bash
   git clone https://github.com/davidjbolt/ms365-mcp-server.git ~/ms365-mcp-server
   cd ~/ms365-mcp-server
   ```

2. Copy the env template:
   ```bash
   cp .env.example .env
   ```

3. Open `.env` and fill in your values:
   ```
   MS365_MCP_CLIENT_ID=<your Application (client) ID from Step 1>
   MS365_MCP_TENANT_ID=<your Directory (tenant) ID from Step 1>
   ```

---

## Step 5 — Run Setup

```bash
./setup.sh
```

This will:
- Verify Node.js is installed
- Check your credentials are set
- Walk you through Microsoft login (device code flow)
- Store your token securely in `~/.config/ms365-mcp/`

---

## Step 6 — Launch Claude Code

```bash
cd ~/ms365-mcp-server
claude
```

Approve the MCP server when prompted. You're ready.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `MS365_MCP_CLIENT_ID not set` | Open `.env` and add your Azure app credentials |
| Login fails / permission denied | Check API permissions in your Azure app registration |
| Token expired | Re-run `./setup.sh` to trigger a new login |
| MCP server not connecting | Make sure you're running `claude` from inside this repo directory |
| Admin consent required error | Contact your IT admin to approve the app registration, or create it under a personal Azure account |
