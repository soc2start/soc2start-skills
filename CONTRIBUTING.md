# Contributing

## Changes to the skill

- The skill lives once, in `skills/soc2start-getting-started/`. All assistants load it from there.
- Keep `SKILL.md` short; put detail in `references/`.
- Tool names must match the SOC2Start MCP server exactly.
- Keep the safeguards: read before write, no invented facts or evidence, confirm before irreversible, notifying or public actions.

## Before opening a pull request

```bash
bash scripts/check.sh
claude plugin validate --strict .
```

Test locally:

```bash
# Claude Code
claude plugin marketplace add ./ && claude plugin install soc2start@soc2start
# Codex
codex plugin marketplace add ./
# Gemini CLI
gemini extensions link .
```

## Releases

1. Bump `version` in all three manifests — `.claude-plugin/plugin.json`, `.codex-plugin/plugin.json`, `gemini-extension.json`. Users don't receive updates otherwise; `scripts/check.sh` fails if they differ.
2. Add an entry to `CHANGELOG.md`.
3. Tag `v<version>` and publish a GitHub release. The release workflow fails on unreplaced `REPLACE_WITH_` placeholders and attaches the skill zip.
