# Connecting SOC2Start to your AI assistant

You need two things from your SOC2Start workspace:

- **MCP endpoint URL** — referred to below as `SOC2START_MCP_URL`
- **API token** for your user — referred to below as `SOC2START_API_TOKEN`

Treat the token like a password: keep it in an environment variable or your client's secret store, never in a committed file. Tools act with your user's permissions, so use an account with the role you want the assistant to have.

After connecting, verify by asking: *"List my SOC2Start organizations."* You should see your organization name.

---

## Claude (claude.ai web, desktop, mobile)

1. Settings → Connectors → **Add custom connector**.
2. Name: `SOC2Start`. URL: `SOC2START_MCP_URL`.
3. Complete the sign-in or paste the token when prompted.
4. Upload this skill: Settings → Capabilities → Skills → upload the `soc2start-getting-started` folder as a zip.

## Claude Code

Install the plugin. It adds this skill and the MCP server, and prompts for the URL and token (the token goes to your system's secure credential store):

```bash
claude plugin marketplace add soc2start/soc2start-skills
claude plugin install soc2start@soc2start
```

Manual alternative:

```bash
claude mcp add --transport http soc2start "$SOC2START_MCP_URL" \
  --header "Authorization: Bearer $SOC2START_API_TOKEN"
mkdir -p ~/.claude/skills
cp -r soc2start-getting-started ~/.claude/skills/
```

## Codex (CLI and IDE extension)

Install the plugin. It adds this skill and the MCP server, and reads the token from `SOC2START_API_TOKEN`:

```bash
export SOC2START_API_TOKEN=<your token>   # add to your shell profile
codex plugin marketplace add soc2start/soc2start-skills
```

Then in Codex: `/plugins` → install **SOC2Start**.

Manual alternative — add to `~/.codex/config.toml`:

```toml
[mcp_servers.soc2start]
url = "SOC2START_MCP_URL"
bearer_token_env_var = "SOC2START_API_TOKEN"
```

and copy the skill: `cp -r soc2start-getting-started ~/.codex/skills/`

If your Codex version does not load skills, add this to the repository's `AGENTS.md`:

```markdown
## SOC2Start
For any SOC2Start / compliance work, read and follow
soc2start-getting-started/SKILL.md and its references/ files.
```

## Gemini CLI

Install the extension. It adds this skill and the MCP server, and prompts for the URL and token (the token goes to your system keychain):

```bash
gemini extensions install https://github.com/soc2start/soc2start-skills
```

Change the values later with `gemini extensions config soc2start`.

Manual alternative — add to `~/.gemini/settings.json`:

```json
{
  "mcpServers": {
    "soc2start": {
      "httpUrl": "SOC2START_MCP_URL",
      "headers": { "Authorization": "Bearer ${SOC2START_API_TOKEN}" }
    }
  }
}
```

and copy the skill: `cp -r soc2start-getting-started ~/.gemini/skills/`

## Cursor, VS Code, Windsurf and other MCP clients

Most clients accept this JSON (`.cursor/mcp.json`, `.vscode/mcp.json`, etc.):

```json
{
  "mcpServers": {
    "soc2start": {
      "url": "SOC2START_MCP_URL",
      "headers": { "Authorization": "Bearer ${SOC2START_API_TOKEN}" }
    }
  }
}
```

Clients without skill support: put `SKILL.md` in the project and reference it from the client's rules file (`.cursor/rules`, `.github/copilot-instructions.md`, `AGENTS.md`).

---

## AI vendor vetting

SOC2Start's automated third-party vetting (`vetThirdParty`) runs inside SOC2Start using your organization's own LLM key (Claude or OpenAI). Configure it in SOC2Start before running phase 7. `getOrganizationLLMConfiguration` shows whether one is set (it never returns the key).

## Troubleshooting

| Symptom | Check |
|---|---|
| No SOC2Start tools appear | Restart the client; confirm the URL and token; `claude mcp list` / `codex mcp list` / `/mcp` in Gemini CLI |
| `listOrganizations` is empty | Your user isn't a member of an organization yet — accept the invite in SOC2Start |
| Permission errors on writes | Your role is read-only; ask an owner to update your membership |
| Client times out on large lists | Ask for smaller pages (`size`) and follow `cursor` |
