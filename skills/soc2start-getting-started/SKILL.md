---
name: soc2start-getting-started
description: Onboard an organization onto SOC2Start.io through its MCP server — company context, framework and gap analysis, policies, measures linked to controls, vendors, risks, data inventory, tasks and audit readiness. Use when the user mentions SOC2Start, wants to start or continue SOC 2 / ISO 27001 compliance work in SOC2Start, or asks to populate, review or update their SOC2Start workspace.
---

# SOC2Start: getting started

SOC2Start.io is a compliance management platform. Its MCP server exposes the workspace (frameworks, controls, measures, documents, risks, vendors, data, tasks, audits, trust center) as tools. This skill walks an organization from an empty workspace to an audit-ready one, in the order that works best.

If the SOC2Start tools are not available in this session, stop and follow `references/setup.md`.

## Ground rules

1. **Resolve the organization first.** Call `listOrganizations`. If there is more than one, ask which one. Reuse that `organization_id` for every call.
2. **Read before you write.** Before adding anything, list what exists (`listMeasures`, `listDocuments`, `listThirdParties`, `listRisks`…) and update instead of duplicating. Lists are paginated — follow `cursor` until it is empty.
3. **IDs are GIDs.** Use the exact IDs returned by tools. `linkMeasure` works out the target type (control, risk, document, third party) from the ID, so never construct IDs by hand.
4. **Never invent facts or evidence.** Company details, owners, vendors, tools and dates come from the user or from files they share. If something is unknown, leave it out and ask, or record it as a task. A measure is `IMPLEMENTED` only when the user confirms it is operating.
5. **Confirm before actions that are hard to undo or reach other people:** any `delete*`, `archive*`, `removeUser`, `inviteUser`/`createUser`, `publishDocument` with approvers, `requestDocumentVersionSignature`, `sendSigningNotifications`, `publish*List`, trust center changes, `vetThirdParty` (it crawls an external site). State what will happen and wait for a yes.
6. **Draft, then publish.** New documents are drafts. Show the user the content (or a summary) before `publishDocument`.
7. **Work in batches the user can review.** For bulk work (e.g. 60 controls), propose the plan as a table first, then execute and report what changed.

## Onboarding sequence

Follow these phases in order. Skip a phase only if `list*` calls show it is already done. Details and tool calls for each phase are in `references/workflows.md`.

| # | Phase | Outcome |
|---|---|---|
| 1 | Organization context | Product, Architecture, Team, Processes, Customers written (`updateOrganizationContext`) |
| 2 | Framework | SOC 2 (or other) framework present; controls listed |
| 3 | Gap analysis | Each control mapped to existing measures or flagged as a gap |
| 4 | Measures | Missing measures created, linked to controls, state set honestly |
| 5 | Policies & procedures | Core policy set drafted as documents, linked to measures, published after review |
| 6 | People | Users invited, owners assigned, security training snapshot recorded |
| 7 | Vendors | Third parties registered, categorized, vetted; DPAs/SOC reports noted |
| 8 | Data & assets | Data inventory with classification and owners; key assets |
| 9 | Risks | Risk register with likelihood/impact, treatment, linked measures |
| 10 | Tasks | Every open gap becomes an owned, dated task |
| 11 | Audit readiness | Audit record created; evidence checked per measure; trust center set up |

Start every session by giving the user a one-paragraph status: which phases are done, what's next. Use `getOrganizationContext`, `listFrameworks`, `listMeasures` (filter by `state`), `listDocuments` and `listTasks` to build it.

## Organization context (phase 1) — do this well

Everything later (policies, risk scenarios, vendor scope, gap analysis) draws on it. Use the five templates in `references/org-context-templates.md`:

- Keep them **framework-neutral** — describe the company as it is, not in SOC 2 language.
- Scope the context to the **system in audit scope** (the product and its supporting infrastructure), not every side project.
- Embed diagrams as **Mermaid** code blocks (architecture, data flow, change process).
- Gather input by asking the user a short set of questions per section, or by reading files they provide (README, architecture docs, IaC, employee list, vendor list). Write the section, show it, then save.

## Writing policies (phase 5)

- One document per policy, `document_type: POLICY` (procedures: `PROCEDURE`, plans like incident response / BCP: `PLAN`).
- Default `classification: INTERNAL`. Ask before setting `trust_center_visibility: PUBLIC`.
- Tailor every policy to the org context (real tools, real roles, real cadences). No placeholder text like "[Company]" in a published document.
- Include: purpose, scope, roles, policy statements, exceptions, review cadence, version history. Template in `references/workflows.md`.
- After creating, `linkMeasure` each related measure to the document.

## Output style

- Report changes as a short table: what was created/updated, its name, linked to what.
- Keep a running list of open questions for the user; don't block on them if other work can proceed.
- When the session ends, summarize: phases completed, items created, gaps remaining, next three actions.

## References

- `references/setup.md` — connect SOC2Start's MCP server to Claude (claude.ai, Desktop, Code), Codex, Cursor and others
- `references/org-context-templates.md` — the five context templates with Mermaid examples
- `references/workflows.md` — step-by-step tool calls for each phase, policy template, starter policy and measure lists
- `references/tool-map.md` — SOC2Start MCP tools grouped by area
