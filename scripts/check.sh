#!/usr/bin/env bash
# Checks that the Claude, Codex and Gemini manifests agree.
# Usage: scripts/check.sh            (CI on every PR)
#        scripts/check.sh --release  (also fails on unreplaced placeholders)
set -euo pipefail
cd "$(dirname "$0")/.."

fail=0
v() { node -e "console.log(require('./$1').$2)"; }

claude_v=$(v .claude-plugin/plugin.json version)
codex_v=$(v .codex-plugin/plugin.json version)
gemini_v=$(v gemini-extension.json version)

if [[ "$claude_v" != "$codex_v" || "$claude_v" != "$gemini_v" ]]; then
  echo "Version mismatch: claude=$claude_v codex=$codex_v gemini=$gemini_v"
  fail=1
fi

for f in .claude-plugin/plugin.json .codex-plugin/plugin.json gemini-extension.json; do
  [[ "$(v "$f" name)" == "soc2start" ]] || { echo "$f: name must be soc2start"; fail=1; }
done

[[ -f skills/soc2start-getting-started/SKILL.md ]] || { echo "Missing skills/soc2start-getting-started/SKILL.md"; fail=1; }

if [[ "${1:-}" == "--release" ]] && grep -rq "REPLACE_WITH_" --include=*.json .; then
  echo "Unreplaced placeholders:"; grep -rn "REPLACE_WITH_" --include=*.json .
  fail=1
fi

[[ $fail -eq 0 ]] && echo "Manifests OK (v$claude_v)"
exit $fail
