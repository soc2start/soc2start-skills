# SOC2Start skills for AI assistants

Get your organization audit-ready in [SOC2Start.io](https://soc2start.io) with Claude, Codex, Gemini CLI or any MCP-capable assistant.

The `soc2start-getting-started` skill walks the assistant through onboarding in order — company context, framework, gap analysis, measures, policies, people, vendors, data, risks, tasks, audit readiness — using SOC2Start's MCP server. It reads before it writes, never invents evidence, and asks before anything irreversible or public.

## Install

You need your SOC2Start **MCP URL** and an **API token** for your user.

### Claude Code

```bash
claude plugin marketplace add soc2start/soc2start-skills
claude plugin install soc2start@soc2start
```

Or in a session: `/plugin install soc2start --marketplace soc2start/soc2start-skills`

Claude Code prompts for the MCP URL and token. The token is stored in your system's secure credential store.

### Codex

```bash
export SOC2START_API_TOKEN=<your token>   # add to your shell profile
codex plugin marketplace add soc2start/soc2start-skills
```

Then in Codex: `/plugins` → install **SOC2Start**.

### Gemini CLI

```bash
gemini extensions install https://github.com/soc2start/soc2start-skills
```

Gemini CLI prompts for the MCP URL and token. The token is stored in your system keychain.

### Claude (claude.ai, Desktop)

1. Settings → Connectors → add SOC2Start as a custom connector with your MCP URL.
2. Settings → Capabilities → Skills → upload `soc2start-getting-started.zip` from the [latest release](https://github.com/soc2start/soc2start-skills/releases/latest).

### Cursor and other assistants

```bash
npx skills add soc2start/soc2start-skills
```

Then connect the MCP server — see [setup.md](skills/soc2start-getting-started/references/setup.md).

## Try it

- "Where are we on SOC 2 in SOC2Start? What's next?"
- "Fill in our organization context. Here's our README and Terraform."
- "Run a gap analysis against the SOC 2 controls and show me the table."
- "Draft our Access Control and Backup policies."
- "Add our vendors from this expense export and vet the critical ones."
- "Are we ready for a Type 1 audit?"

## Repository layout

One skill, packaged for each assistant:

```
skills/soc2start-getting-started/    The skill (shared by all assistants)
├── SKILL.md
└── references/

.claude-plugin/plugin.json           Claude Code plugin (MCP server + config prompts)
.claude-plugin/marketplace.json      Claude Code marketplace
.codex-plugin/plugin.json            Codex plugin
.agents/plugins/marketplace.json     Codex marketplace
codex.mcp.json                       Codex MCP server
gemini-extension.json                Gemini CLI extension (MCP server + settings)
scripts/check.sh                     Keeps the three manifests in sync
```

## Contributing

Issues and pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## Security

Report vulnerabilities privately — see [SECURITY.md](SECURITY.md). Never put API tokens in issues, pull requests or committed files.

## License

[MIT](LICENSE)
